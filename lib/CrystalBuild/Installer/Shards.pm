package CrystalBuild::Installer::Shards;
use strict;
use warnings;
use utf8;

use File::Copy qw/copy/;   # >= 5.002
use File::Path qw/mkpath/; # >= 5.001
use File::Spec; # >= 5.00405

use CrystalBuild::Utils;
use CrystalBuild::Resolver::Shards;
use CrystalBuild::Downloader::Shards;
use CrystalBuild::Builder::Shards;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub fetcher    { shift->{fetcher}    }
sub shards_url { shift->{shards_url} }
sub cache_dir  { shift->{cache_dir}  }

sub install {
    my ($self, $crystal_version, $crystal_dir) = @_;

    print "Resolving shards download URL ... ";
    my $tarball_url = $self->_resolve($crystal_version);
    print "ok\n";

    print "Downloading shards tarball ...\n";
    my $target_dir = $self->_download($tarball_url);
    print "ok\n";

    print "Building shards ... ";
    my $shards_bin = $self->_build($target_dir, $crystal_dir);
    print "ok\n";

    print "Copying shards binary ... ";
    $self->_copy($shards_bin, $crystal_dir);
    print "ok\n";
}

sub _resolve {
    my ($self, $crystal_version) = @_;

    return CrystalBuild::Resolver::Shards->new(
        fetcher    => $self->fetcher,
        shards_url => $self->shards_url,
    )->resolve($crystal_version);
}

sub _download {
    my ($self, $tarball_url) = @_;

    return CrystalBuild::Downloader::Shards->new(
        fetcher    => $self->fetcher,
        cache_dir  => $self->cache_dir,
    )->download($tarball_url);
}

sub _build {
    my ($self, $target_dir, $crystal_dir) = @_;
    return CrystalBuild::Builder::Shards->new->build($target_dir, $crystal_dir);
}

sub _copy {
    my ($self, $shards_bin, $crystal_dir) = @_;

    my $target_dir  = File::Spec->catfile($crystal_dir, 'bin');
    my $target_path = File::Spec->catfile($target_dir, 'shards');

    copy($shards_bin, $target_path)
        or CrystalBuild::Utils::error_and_exit('shards binary copy failed: '.$target_path);

    chmod 0755, $target_path;
}

1;
