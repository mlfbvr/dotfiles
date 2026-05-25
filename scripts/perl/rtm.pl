#!/usr/bin/env perl
# scripts/perl/rtm.pl — Remember The Milk CLI
use strict;
use warnings;
use v5.30;

use HTTP::Tiny;
use Digest::MD5 qw(md5_hex);
use JSON::PP;
use URI::Escape qw(uri_escape_utf8);

# RTM API endpoints
my $API_URL       = 'https://api.rememberthemilk.com/services/rest/';
my $AUTH_URL      = 'https://www.rememberthemilk.com/services/auth/';

# Credentials from environment — never hardcoded
my $API_KEY       = $ENV{RTM_API_KEY}       // '';
my $SHARED_SECRET = $ENV{RTM_SHARED_SECRET} // '';
my $AUTH_TOKEN    = $ENV{RTM_AUTH_TOKEN}    // '';

# Parse CLI args: <list> add|view | setup
sub main {
    my $cmd = shift @ARGV;
    usage() unless $cmd;

    # Run once to get an auth token — saved as RTM_AUTH_TOKEN in env
    if ($cmd eq 'setup') {
        setup_auth();
        return;
    }

    my $list_name = $cmd;
    my $action    = shift @ARGV // usage();

    die "RTM_API_KEY and RTM_SHARED_SECRET must be set\n"
        unless $API_KEY && $SHARED_SECRET;
    die "RTM_AUTH_TOKEN must be set\n"
        unless $AUTH_TOKEN;

    my $list_id = get_list_id($list_name);

    if ($action eq 'add') {
        my $task_name = shift @ARGV // usage();
        add_task($list_id, $task_name);
    } elsif ($action eq 'view') {
        view_list($list_id);
    } else {
        usage();
    }
}

sub usage {
    say "Usage:";
    say "  $0 setup";
    say "  $0 <list-name> add <task-name>";
    say "  $0 <list-name> view";
    exit 1;
}

# One-time desktop auth flow: getFrob → auth URL → getToken.
# Resulting token is persistent — set RTM_AUTH_TOKEN and never run setup again.
sub setup_auth {
    die "RTM_API_KEY and RTM_SHARED_SECRET must be set\n"
        unless $API_KEY && $SHARED_SECRET;

    my $frob = api_call('rtm.auth.getFrob', {})->{frob};

    my %params = (
        api_key => $API_KEY,
        perms   => 'write',
        frob    => $frob,
    );
    my $sig     = sign_params(\%params);
    my $auth_url = $AUTH_URL . '?' . url_encode_params(\%params) . "&api_sig=$sig";

    say "Open this URL in your browser and authorize the application:";
    say $auth_url;
    say "";
    say "Press Enter after authorizing...";
    <STDIN>;

    my $token = api_call('rtm.auth.getToken', { frob => $frob })->{auth}{token};
    say "Auth token: $token";
    say "";
    say "Add this to your shell config (e.g. ~/.bashrc or ~/.zshrc):";
    say "  export RTM_AUTH_TOKEN=$token";
}

# Create timeline, then add task with Smart Add (parse=1).
# A timeline is RTM's concept for grouping mutations (add/edit/complete/delete)
# that should be applied atomically. We create a fresh one per call since we
# have no batching need, but RTM still requires a timeline for write operations.
sub add_task {
    my ($list_id, $task_name) = @_;

    my $timeline = api_call('rtm.timelines.create', {})->{timeline};

    api_call('rtm.tasks.add', {
        timeline => $timeline,
        list_id  => $list_id,
        name     => $task_name,
        parse    => 1,
    });

    say "Added: $task_name";
}

# Walk JSON structure to extract task name + completion status
sub view_list {
    my ($list_id) = @_;

    my $result = api_call('rtm.tasks.getList', { list_id => $list_id });

    my $tasks = $result->{tasks};
    unless ($tasks && $tasks->{list}) {
        say "(empty)";
        return;
    }

    # RTM returns a single object when there's one result, an array otherwise
    my @lists = ref $tasks->{list} eq 'ARRAY' ? @{$tasks->{list}} : ($tasks->{list});

    for my $list (@lists) {
        my @series = ref $list->{taskseries} eq 'ARRAY'
            ? @{$list->{taskseries}}
            : ($list->{taskseries});

        for my $ts (@series) {
            my $name   = $ts->{name};
            my $task   = $ts->{task};
            my @tasks  = ref $task eq 'ARRAY' ? @$task : ($task);

            for my $t (@tasks) {
                my $completed = defined $t->{completed} && $t->{completed} ne '' ? 1 : 0;
                say $completed ? "[✓] $name" : "[ ] $name";
            }
        }
    }
}

# Build params, sign with MD5, POST, parse JSON response
sub api_call {
    my ($method, $extra_params) = @_;

    my %params = (
        method  => $method,
        api_key => $API_KEY,
        format  => 'json',
        v       => 2,
    );

    # getFrob/getToken are called before we have a token
    if ($AUTH_TOKEN
        && $method ne 'rtm.auth.getFrob'
        && $method ne 'rtm.auth.getToken')
    {
        $params{auth_token} = $AUTH_TOKEN;
    }

    while (my ($k, $v) = each %$extra_params) {
        $params{$k} = $v;
    }

    # RTM signing: MD5(secret + sorted key-value pairs)
    $params{api_sig} = sign_params(\%params);

    my $http     = HTTP::Tiny->new;
    my $response = $http->post_form($API_URL, \%params);

    unless ($response->{success}) {
        die "HTTP error: $response->{status} $response->{reason}\n";
    }

    my $json = eval { JSON::PP->new->utf8->decode($response->{content}) };
    die "Invalid JSON response: $@\n" if $@;

    if ($json->{rsp}{stat} ne 'ok') {
        my $err  = $json->{rsp}{err};
        my $code = $err->{code} // 'unknown';
        my $msg  = $err->{msg}  // 'Unknown error';
        die "API error [$code]: $msg\n";
    }

    return $json->{rsp};
}

# Implements RTM signature algorithm: MD5(secret + sorted key=value pairs)
sub sign_params {
    my ($params) = @_;

    my $sig = $SHARED_SECRET;
    for my $key (sort keys %$params) {
        next if $key eq 'api_sig';
        $sig .= $key . $params->{$key};
    }
    return md5_hex($sig);
}

# Fetch all lists, find case-insensitive exact match by name
sub get_list_id {
    my ($name) = @_;

    my $result = api_call('rtm.lists.getList', {});
    my $lists  = $result->{lists};

    die "No lists found\n" unless $lists && $lists->{list};

    my @lists = ref $lists->{list} eq 'ARRAY' ? @{$lists->{list}} : ($lists->{list});

    my @matches = grep { lc $_->{name} eq lc $name } @lists;

    if (@matches > 1) {
        die "Multiple lists found matching '$name'\n";
    }

    unless (@matches) {
        my @names = sort map { $_->{name} } @lists;
        die "List '$name' not found.\nAvailable lists:\n  " . join("\n  ", @names) . "\n";
    }

    return $matches[0]{id};
}

# Build URL query string for the auth redirect URL
sub url_encode_params {
    my ($params) = @_;
    return join '&', map {
        uri_escape_utf8($_) . '=' . uri_escape_utf8($params->{$_})
    } sort keys %$params;
}

main();
