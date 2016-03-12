package CrystalBuild::Resolver::Crystal;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use CrystalBuild::GitHub;
use CrystalBuild::Resolver::Crystal::GitHub;
use CrystalBuild::Resolver::Crystal::RemoteCache;

sub new {
    my ($class, %opt) = @_;
    my $self = bless { } => $class;

    $self->{fetcher}           = $opt{fetcher};
    $self->{github_repository} = $opt{github_repository};
    $self->{remote_cache_url}  = $opt{remote_cache_url};
    $self->{use_remote_cache}  = $opt{use_remote_cache};
    $self->{use_github}        = $opt{use_github};
    $self->{resolvers}         = $self->_create_enable_resolvers;

    return $self;
}

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    for my $resolver (@{ $self->{resolvers} }) {
        my $download_url = $resolver->resolve($version, $platform, $arch);
        return $download_url if defined $download_url;
    }

    die 'version not found';
}

sub versions {
    my $self = shift;

    for my $resolver (@{ $self->{resolvers} }) {
        my $versions = eval { $resolver->versions };
        return $versions unless $@;

        say $@;
    }

    die 'faild to fetch Crystal versions list';
}

sub _create_enable_resolvers {
    my $self = shift;
    return [
        $self->{use_remote_cache} ? $self->_create_remote_cache_resolver : (),
        $self->{use_github}       ? $self->_create_github_resolver       : (),
    ];
}

sub _create_remote_cache_resolver {
    my $self = shift;
    return CrystalBuild::Resolver::Crystal::RemoteCache->new(
        fetcher   => $self->{fetcher},
        cache_url => $self->{remote_cache_url},
    );
}

sub _create_github_resolver {
    my $self = shift;
    return CrystalBuild::Resolver::Crystal::GitHub->new(
        github => CrystalBuild::GitHub->new(
            fetcher     => $self->{fetcher},
            github_repo => $self->{github_repository},
        ),
    );
}

1;
