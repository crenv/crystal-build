package CrystalBuild::Downloader::Shards;
use strict;
use warnings;
use utf8;

use File::Spec;

use CrystalBuild::Utils;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub fetcher   { shift->{fetcher}   }
sub cache_dir { shift->{cache_dir} }

sub download {
    my ($self, $tarball_url) = @_;

    my $filename     = $self->_detect_filename($tarball_url);
    my $tarball_path = File::Spec->join($self->cache_dir, $filename);

    $self->fetcher->download($tarball_url, $tarball_path)
        or CrystalBuild::Utils::error_and_exit("download faild: $tarball_url");

    CrystalBuild::Utils::extract_tar($tarball_path, $self->cache_dir);

    my ($target_dir) = glob File::Spec->join($self->cache_dir, 'shards-*');
    return $target_dir;
}

sub _detect_filename {
    my ($self, $url) = @_;

    return "shards-$1" if $url =~ /\/([\w\.-]+)$/;
    return 'shards.tar.gz';
}

1;
