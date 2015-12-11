package CrystalBuild::Installer::Shards;
use strict;
use warnings;
use utf8;

use File::Path qw/mkpath/; # >= perl 5.001

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

    print "Downloading shards tarball ... ";
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

   my $builder = CrystalBuild::Builder::Shards->new;
   return $builder->build($target_dir, $crystal_dir);
}

sub _copy {
    my ($self, $shards_bin, $crystal_dir) = @_;

    my $target_dir  = $crystal_dir.'/bin';
    my $target_path = $target_dir.'/shards';

    # unlink $target_path if -f $target_path;
    # mkpath $target_dir unless -d $target_dir;
    system("cp \"$shards_bin\" \"$target_path\"") == 0
        or CrystalBuild::Utils::error_and_exit('shards binary copy failed: '.$target_path);
}

1;
