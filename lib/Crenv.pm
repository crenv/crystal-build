package Crenv;
use strict;
use warnings;
use utf8;
use feature qw/say/;
our $VERSION = '1.1.2';

use File::Path qw/rmtree mkpath/;
use JSON::PP;

use Crenv::Utils;
use Crenv::GitHub;
use Crenv::Resolver::GitHub;
use Crenv::Resolver::Cache::Remote;
use Crenv::Resolver::Shards;
use Crenv::Installer::Shards;

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

    Crenv::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = glob "$cache_dir/crystal-*/";
    rename $target_dir, $self->get_install_dir or die "Error: $!";

    # shards
    if (Crenv::Utils::cmp_version($version, '0.7.7') >= 0) { # >= v0.7.7
        $self->install_shards($version);
    }

    say 'Install successful';
}

sub install_shards {
    my ($self, $crystal_version) = @_;

    my $installer = Crenv::Installer::Shards->new(
        fetcher    => $self->{fetcher},
        shards_url => $self->{shards_url},
        cache_dir  => "$self->{cache_dir}/$crystal_version",
    );

    $installer->install($crystal_version, $self->{prefix});
}

sub show_definitions {
    my $self = shift;
    say $_ for @{ Crenv::Utils::sort_version($self->avaiable_versions) };
}

sub resolvers {
    my $self = shift;

    my @resolvers;

    push @resolvers, [
        'remote cache',
        Crenv::Resolver::Cache::Remote->new(
            fetcher   => $self->{fetcher},
            cache_url => $self->{cache_url},
        )
    ] if $self->cache;

    push @resolvers, [
        'GitHub',
        Crenv::Resolver::GitHub->new(github => $self->github)
    ];

    return \@resolvers;
}

sub avaiable_versions {
    my $self = shift;

    my @versions = map { $self->normalize_version($_) } @{ $self->versions };
    return \@versions;
}

sub system_info {
    my $self = shift;

    my ($platform, $arch) = Crenv::Utils::system_info();
    return ($platform, $arch);
}

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    for my $resolver (@{ $self->resolvers }) {
        print 'resolve by ' . $resolver->[0] . ': ';
        my $download_url = $resolver->[1]->resolve($version, $platform, $arch);
        say defined $download_url ? 'found' : 'not found';
        return $download_url if defined $download_url;
    }

    error_and_exit('version not found');
}

sub versions {
    my $self = shift;

    for my $resolver (@{ $self->resolvers }) {
        my $versions = $resolver->[1]->versions;
        return $versions;
    }

    error_and_exit('avaiable versions not found');
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

    Crenv::GitHub->new(
        fetcher     => $self->{fetcher},
        github_repo => $self->{github_repo},
    );
}

sub cache { shift->{cache} }

1;
