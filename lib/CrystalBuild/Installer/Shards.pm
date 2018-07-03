package CrystalBuild::Installer::Shards;
use strict;
use warnings;
use utf8;

use File::Copy qw/copy/;   # >= 5.002
use File::Path qw/mkpath/; # >= 5.001
use File::Spec;            # >= 5.00405

use CrystalBuild::Utils;
use CrystalBuild::Resolver::Shards;
use CrystalBuild::Downloader::Shards;
use CrystalBuild::Builder::Shards;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub fetcher          { shift->{fetcher} }
sub remote_cache_url { shift->{remote_cache_url} }
sub cache_dir        { shift->{cache_dir} }
sub without_release  { shift->{without_release} }

sub install {
    my ($self, $crystal_version, $crystal_dir) = @_;
    my $shards_install_path = $self->_shards_install_path($crystal_dir);

    eval {
        print "Checking if Shards already exists ... ";
        return print "ok\n" if -f $shards_install_path;
        print "ng\n";

        print "Resolving Shards download URL ... ";
        my $tarball_url = $self->_resolve($crystal_version);
        print "ok\n";

        print "Downloading Shards tarball ...\n";
        print "$tarball_url\n";
        my $target_dir = $self->_download($tarball_url, $crystal_version);
        print "ok\n";

        print "Building Shards ... ";
        my $shards_bin = $self->_build($target_dir, $crystal_dir);
        print "ok\n";

        print "Copying Shards binary ... ";
        $self->_copy($shards_bin, $shards_install_path);
        print "ok\n";
    };

    CrystalBuild::Utils::error_and_exit($@) if $@;
}

sub _resolve {
    my ($self, $crystal_version) = @_;
    return CrystalBuild::Resolver::Shards->new(
        fetcher             => $self->fetcher,
        shards_releases_url => $self->remote_cache_url,
    )->resolve($crystal_version);
}

sub _download {
    my ($self, $tarball_url, $crystal_version) = @_;
    my $cache_dir = $self->cache_dir.'/'.$crystal_version;
    return CrystalBuild::Downloader::Shards->new(
        fetcher => $self->fetcher,
    )->download($tarball_url, $cache_dir);
}

sub _build {
    my ($self, $target_dir, $crystal_dir) = @_;
    return CrystalBuild::Builder::Shards->new(
        without_release => $self->without_release,
    )->build($target_dir, $crystal_dir);
}

sub _copy {
    my ($self, $shards_bin, $shards_install_path) = @_;

    copy($shards_bin, $shards_install_path)
        or die 'shards binary copy failed: '.$shards_install_path;

    chmod 0755, $shards_install_path;
}

sub _shards_install_path {
    my ($self, $crystal_dir) = @_;
    return File::Spec->catfile($crystal_dir, 'bin', 'shards');
}

1;
