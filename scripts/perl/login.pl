#!/usr/bin/env perl
use strict;
use warnings;

my $user = getpwuid($<) || $ENV{USER} || 'unknown';
my @now  = localtime(time);
my $date = sprintf '%04d-%02d-%02d', $now[5] + 1900, $now[4] + 1, $now[3];
my $time = sprintf '%02d:%02d:%02d', $now[2], $now[1], $now[0];

print "Welcome, $user.\n";

my $mailbox = "/var/mail/$user";
if (-r $mailbox && -f _) {
    open my $fh, '<', $mailbox or die "mail: $!";
    my $lines = 0;
    $lines++ while <$fh>;
    close $fh;

    if ($lines > 0) {
        my $msg = $lines == 1 ? 'message' : 'messages';
        print "You have $lines $msg waiting in your mailbox.\n";
    } else {
        print "No mail.\n";
    }
}

print "Current date and time: $date $time\n";
