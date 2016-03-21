package CrystalBuild::Downloader::Shards;
use strict;
use warnings;
use utf8;
use parent qw/CrystalBuild::Downloader::Tarball/;

use File::Spec;

sub _detect_filename {
    my ($self, $url) = @_;

    return "shards-$1" if $url =~ /\/([\w\.-]+)$/;
    return 'shards.tar.gz';
}

sub _detect_extracted_dirs {
    my ($self, $cache_dir) = @_;
    return grep { -d $_ } glob File::Spec->join($cache_dir, 'shards-*');
}

1;
