#!/usr/bin/env perl
# scripts/perl/download_organizer.pl — Sort downloads into category folders
#
# Scans a directory (default ~/Downloads) and moves recognized files into
# subdirectories: Pictures, Documents, Audio, Video, Archives, Images, Code.
# Only top-level regular files are processed — hidden files, symlinks, and
# subdirectories are skipped. Unknown file types are left in place.
#
# Environment:
#   DOWNLOAD_ORGANIZER_DRY_RUN=1   preview without moving anything
#   DOWNLOAD_ORGANIZER_VERBOSE=1   print each action as it happens
#
# Usage: perl scripts/perl/download_organizer.pl [target_dir]

use strict;
use warnings;
use File::Copy qw(move);
use File::Basename qw(fileparse);

# ── Category definitions ──────────────────────────────────────────────────

# Compound extensions checked before falling back to single-ext lookup
my @compounds = qw(tar.gz tar.xz tar.bz2 tar.zst);

my %ext_to_cat;

sub init_categories {
    my %map = (
        Pictures  => [qw(jpg jpeg png gif bmp tiff tif webp svg ico heic heif)],
        Documents => [qw(pdf doc docx xls xlsx ppt pptx txt md csv rtf odt ods odp
                         epub mobi)],
        Audio     => [qw(mp3 wav flac aac ogg wma m4a opus aiff alac)],
        Video     => [qw(mp4 mkv avi mov wmv flv webm m4v mpeg mpg)],
        Archives  => [qw(zip tar gz bz2 xz rar 7z tgz zst
                         deb rpm apk pkg flatpakref flatpak snap)],
        Code      => [qw(pl pm py c h cpp hpp cc cxx ts tsx js jsx go rs java rb
                         sh bash zsh php swift kt kts scala lua r sql vim
                         lisp clj hs ml ex exs dart asm m)],
        Images    => [qw(img iso)],
    );

    while (my ($cat, $exts) = each %map) {
        $ext_to_cat{$_} = $cat for @$exts;
    }

    # Register compound extensions under the same category as their last segment
    for my $compound (@compounds) {
        my $last = (split /\./, $compound)[-1];
        $ext_to_cat{$compound} = $ext_to_cat{$last} if $ext_to_cat{$last};
    }
}

init_categories();

# ── Configuration ─────────────────────────────────────────────────────────

my $TARGET  = shift @ARGV // glob('~/Downloads');
my $DRY_RUN = $ENV{DOWNLOAD_ORGANIZER_DRY_RUN} // 0;
my $VERBOSE = $ENV{DOWNLOAD_ORGANIZER_VERBOSE} // 0;

# Expand leading ~/ and ~user/ to full paths
if ($TARGET =~ m{^~(/.*)?$}) {
    $TARGET = $1 ? $ENV{HOME} . $1 : $ENV{HOME};
} elsif ($TARGET =~ m{^~(\w+)(/.*)?$}) {
    my ($user, $rest) = ($1, $2 // '');
    my ($pw_uid) = getpwnam($user);
    die "Unknown user: $user\n" unless defined $pw_uid;
    my $home = (getpwuid($pw_uid))[7];
    $TARGET = $home . $rest;
}

die "Target directory does not exist: $TARGET\n" unless -d $TARGET;

# ── Process files ────────────────────────────────────────────────────────

opendir my $dh, $TARGET or die "Cannot open $TARGET: $!\n";

my $errors = 0;

while (my $entry = readdir $dh) {
    next if $entry eq '.' || $entry eq '..';
    next if substr($entry, 0, 1) eq '.';     # skip hidden files

    my $path = "$TARGET/$entry";
    next unless -f $path && !-l $path;        # regular files only

    my $category = classify_file($entry);
    next unless $category;                    # unknown — leave in place

    my $dest_dir = "$TARGET/$category";

    unless (-d $dest_dir) {
        print "mkdir $dest_dir\n" if $VERBOSE;
        unless ($DRY_RUN) {
            mkdir $dest_dir or do {
                warn "Cannot create $dest_dir: $!\n";
                $errors++;
                next;
            };
        }
    }

    my $dest_path = "$dest_dir/$entry";

    if (-e $dest_path) {
        warn "Skipping $entry — target exists: $dest_path\n";
        $errors++;
        next;
    }

    if ($DRY_RUN) {
        print "[DRY RUN] mv $entry -> $category/\n";
        next;
    }

    move($path, $dest_path) or do {
        warn "Cannot move $entry: $!\n";
        $errors++;
    };

    print "mv $entry -> $category/\n" if $VERBOSE;
}

closedir $dh;

exit $errors ? 1 : 0;

# ── Helpers ───────────────────────────────────────────────────────────────

# Determine the category for a filename based on extension.
# Compound extensions (tar.gz, tar.xz, etc.) are checked first, then
# single extensions.  Returns the category name or undef for unknown types.
sub classify_file {
    my ($filename) = @_;

    my $lower = lc $filename;

    # Check compound extensions first (e.g. .tar.gz, .tar.xz)
    for my $compound (@compounds) {
        my $suffix = ".$compound";
        next unless length($lower) > length($suffix)
                    && substr($lower, -length($suffix)) eq $suffix;
        return $ext_to_cat{$compound};
    }

    # Fall back to single extension via fileparse
    my ($name, undef, $ext) = fileparse($filename, qr/\.[^.]*/);
    return unless $ext;

    $ext = lc $ext;
    $ext = substr($ext, 1);                 # strip leading dot

    return $ext_to_cat{$ext};
}
