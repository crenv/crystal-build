package CrystalBuild::Installer::Crystal;
use strict;
use warnings;
use utf8;

use CrystalBuild::Utils;
use CrystalBuild::Resolver::Crystal;

sub new {
    my ($class, %opt) = @_;
    my $self = bless {} => $class;

    $self->{fetcher}  = $opt{fetcher};
    $self->{resolver} = $self->_create_resolver(%opt);

    return $self;
}

sub install {
}

sub versions {
    my $self     = shift;
    my $versions = eval { $self->{resolver}->versions };

    CrystalBuild::Utils::error_and_exit('avaiable versions not found') if $@;

    return $versions;
}

sub _create_resolver {
    my ($self, %opt) = @_;
    return CrystalBuild::Resolver::Crystal->new(
        fetcher           => $opt{fetcher},
        github_repository => $opt{github_repository},
        remote_cache_url  => $opt{remote_cache_url},
        use_remote_cache  => $opt{use_remote_cache},
        use_github        => $opt{use_github},
    );
}

1;
