#!/usr/bin/env perl
# scripts/perl/find_duplicates.pl — Scan current directory for duplicate files
#
# Scans all regular files (not symlinks) in the current directory, computes
# their MD5 checksum, and prints groups of files that share the same digest.
# Hidden files are included. Only core Perl modules are used.
#
# Usage: perl scripts/perl/find_duplicates.pl
#   Exit 0 — no duplicates found
#   Exit 1 — at least one group of duplicates was reported

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);

# Phase 1: scan directory and compute checksums
my %dups;

opendir my $dh, '.' or die "Cannot open current directory: $!\n";

while (my $entry = readdir $dh) {
    next if $entry eq '.' || $entry eq '..';
    next unless -f $entry && !-l $entry;

    my $path = "./$entry";

    open my $fh, '<:raw', $entry or do {
        warn "Cannot read $path: $!\n";
        next;
    };

    # Read in 8 KB chunks to avoid memory spikes on large files
    my $ctx = Digest::MD5->new;
    while (read $fh, my $buf, 8192) {
        $ctx->add($buf);
    }
    close $fh;

    push @{$dups{$ctx->hexdigest}}, $path;
}

closedir $dh;

# Phase 2: report groups with more than one file
my $found = 0;

for my $digest (sort keys %dups) {
    my @files = @{$dups{$digest}};
    next unless @files > 1;

    $found = 1;
    print "$digest\n";
    print "  $_\n" for @files;
    print "\n";
}

exit $found ? 1 : 0;
