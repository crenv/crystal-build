package CrystalBuild::Downloader::Crystal;
use strict;
use warnings;
use utf8;

use File::Spec;
use File::Path qw/rmtree mkpath/; # => 5.001

use CrystalBuild::Utils;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub fetcher   { shift->{fetcher}   }

sub download {
    my ($self, $tarball_url, $cache_dir) = @_;

    my $filename     = $self->_detect_filename($tarball_url);
    my $tarball_path = File::Spec->join($cache_dir, $filename);

    mkpath $cache_dir unless -e $cache_dir;
    $self->fetcher->download($tarball_url, $tarball_path)
        or die "download faild: $tarball_url";

    rmtree $_ for $self->_detect_extracted_dirs($cache_dir);

    CrystalBuild::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = $self->_detect_extracted_dirs($cache_dir);
    return $target_dir;
}

sub _detect_filename {
    my ($self, $url) = @_;

    return $1 if $url =~ /\/([\w\.-]+)$/;
    return 'crystal.tar.gz';
}

sub _detect_extracted_dirs {
    my ($self, $cache_dir) = @_;
    return grep { -d $_ } glob File::Spec->join($cache_dir, 'crystal-*');
}

1;
