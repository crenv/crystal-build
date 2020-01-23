package CrystalBuild::Downloader::Crystal;
use strict;
use warnings;
use utf8;
use parent qw/CrystalBuild::Downloader::Tarball/;

use File::Spec;

sub _detect_filename {
    my ($self, $url) = @_;

    return $1 if $url && $url =~ /\/([\w\.-]+)$/;
    die 'Invalid download URL';
}

sub _detect_extracted_dirs {
    my ($self, $cache_dir) = @_;
    my $matches = [
        glob(File::Spec->join($cache_dir, 'crystal')),   # for Homebrew bottles
        glob(File::Spec->join($cache_dir, 'crystal-*')), # for GitHub releases
    ];
    return grep { -d $_ } @$matches;
}

1;
