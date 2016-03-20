package CrystalBuild;
use strict;
use warnings;
use utf8;
use feature qw/say state/;
our $VERSION = '1.1.6';

use File::Path qw/rmtree mkpath/;
use JSON::PP;
use SemVer::V2::Strict;

use CrystalBuild::Utils;
use CrystalBuild::GitHub;
use CrystalBuild::Resolver::Crystal;
use CrystalBuild::Resolver::Crystal::GitHub;
use CrystalBuild::Resolver::Crystal::RemoteCache;
use CrystalBuild::Installer::Crystal;
use CrystalBuild::Installer::Shards;

sub new {
    my ($class, %opt) = @_;

    my $self = +{ %opt };
    return bless $self => $class;
}

sub install {
    my ($self, $v) = @_;


    my ($platform, $arch) = $self->system_info;

    my $version      = $self->normalize_version($v);
    my $cache_dir    = "$self->{cache_dir}/$version";
    my $target_name  = "crystal-$version-$platform-$arch";
    my $tarball_path = "$cache_dir/$target_name.tar.gz";

    say "resolve: $target_name";
    my $tarball_url = $self->resolve($version, $platform, $arch);

    # clean
    $self->clean($version);
    mkpath $cache_dir;

    say "fetch: $tarball_url";
    $self->{fetcher}->download($tarball_url, $tarball_path)
        or error_and_exit("download faild: $tarball_url");

    CrystalBuild::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = glob "$cache_dir/crystal-*/";
    rename $target_dir, $self->get_install_dir or die "Error: $!";

    # shards
    my $v077 = SemVer::V2::Strict->new('0.7.7');
    if (SemVer::V2::Strict->new($version) >= $v077) { # >= v0.7.7
        $self->install_shards($version);
    }

    say 'Install successful';
}

sub install_shards {
    my ($self, $crystal_version) = @_;

    my $installer = CrystalBuild::Installer::Shards->new(
        fetcher          => $self->{fetcher},
        remote_cache_url => $self->{shards_url},
        cache_dir        => "$self->{cache_dir}/$crystal_version",
    );

    $installer->install($crystal_version, $self->{prefix});
}

sub crystal_installer {
    my $self = shift;
    state $installer = CrystalBuild::Installer::Crystal->new(
        fetcher           => $self->{fetcher},
        github_repository => $self->{github_repo},
        remote_cache_url  => $self->{cache_url},
        use_remote_cache  => $self->cache,
        use_github        => 1,
    );

    return $installer;
}

sub show_definitions {
    my $self = shift;
    say $_ for @{ CrystalBuild::Utils::sort_version($self->avaiable_versions) };
}

sub composite_resolver {
    my $self = shift;
    return CrystalBuild::Resolver::Crystal->new(
        fetcher           => $self->{fetcher},
        github_repository => $self->{github_repo},
        remote_cache_url  => $self->{cache_url},
        use_remote_cache  => $self->cache,
        use_github        => 1,
    );
}

sub avaiable_versions {
    my $self = shift;

    my @versions = map { $self->normalize_version($_) } @{ $self->versions };
    return \@versions;
}

sub system_info {
    my $self = shift;

    my ($platform, $arch) = CrystalBuild::Utils::system_info();
    return ($platform, $arch);
}

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    my $result = eval { $self->composite_resolver->resolve($version, $platform, $arch) };

    say $@ if $@;
    return $result;
}

sub versions {
    my $self = shift;
    return $self->crystal_installer->versions;
}

sub get_install_dir {
    my $self = shift;

    my $dir = $self->{prefix};
    rmtree $dir if -d $dir;
    mkpath $dir unless -e $dir;

    return $dir;
}

sub normalize_version {
    my ($self, $v) = @_;

    error_and_exit('version is required') unless $v;

    return $v if $v =~ m/^\d+\.?(\d+|x)?\.?(\d+|x)?$/;
    return do { $v =~ s/v//; $v } if $v =~ m/^v\d+\.?(\d+|x)?\.?(\d+|x)?$/;
    return $v;
}

sub error_and_exit {
    my $msg = shift;

    say $msg;
    exit 1;
}

sub clean {
    my ($self, $version) = @_;

    my $dir = "$self->{cache_dir}/$version";
    rmtree $dir if -d $dir;
}

sub github {
    my $self = shift;

    CrystalBuild::GitHub->new(
        fetcher     => $self->{fetcher},
        github_repo => $self->{github_repo},
    );
}

sub cache { shift->{cache} }

1;
