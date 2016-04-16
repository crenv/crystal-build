package CrystalBuild::Resolver::Crystal;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use CrystalBuild::Utils;
use CrystalBuild::GitHub;
use CrystalBuild::Resolver::Utils;
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
        print 'Resolving Crystal download URL by '.$resolver->name.' ... ';
        my $download_url = $resolver->resolve($version, $platform, $arch);

        if (defined $download_url) {
            say 'ok';
            return $download_url;
        }

        say 'ng';
    }

    die "Error: Version not found\n";
}

sub resolve_by_version {
    my ($self, $version) = @_;
    my ($platform, $arch) = CrystalBuild::Utils::system_info();
    return $self->resolve($version, $platform, $arch);
}

sub versions {
    my $self = shift;

    for my $resolver (@{ $self->{resolvers} }) {
        my $versions = eval { $resolver->versions };
        return $versions if !$@ && @$versions > 0;

        say $@ if $@;
    }

    die "faild to fetch Crystal versions list\n";
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
