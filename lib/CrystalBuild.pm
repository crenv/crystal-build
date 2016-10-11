package CrystalBuild;
use CrystalBuild::Sense;

our $VERSION = '1.3.1';

use File::Path qw/rmtree mkpath/;
use JSON::PP;
use SemVer::V2::Strict;

use CrystalBuild::Utils;
use CrystalBuild::GitHub;
use CrystalBuild::Installer::Crystal;
use CrystalBuild::Installer::Shards;
use CrystalBuild::Resolver::Utils;

sub new {
    my ($class, %opt) = @_;

    my $self = +{ %opt };
    return bless $self => $class;
}

sub install {
    my ($self, $v) = @_;
    my $version = CrystalBuild::Resolver::Utils->normalize_version($v);

    $self->crystal_installer->install($version, $self->{prefix});
    if ($self->crystal_installer->needs_shards($version)) {
        $self->shards_installer->install($version, $self->{prefix});
    }

    say 'Install successful';
}

sub crystal_installer {
    my $self = shift;
    state $installer = CrystalBuild::Installer::Crystal->new(
        fetcher           => $self->{fetcher},
        github_repository => $self->{github_repo},
        remote_cache_url  => $self->{cache_url},
        cache_dir         => $self->{cache_dir},
        use_remote_cache  => $self->use_remote_cache,
        use_github        => 1,
    );
    return $installer;
}

sub shards_installer {
    my $self = shift;
    state $installer = CrystalBuild::Installer::Shards->new(
        fetcher          => $self->{fetcher},
        remote_cache_url => $self->{shards_url},
        cache_dir        => $self->{cache_dir},
    );
    return $installer;
}

sub show_definitions {
    my $self = shift;
    say $_ for @{ $self->crystal_installer->versions };
}

sub get_install_dir {
    my $self = shift;

    my $dir = $self->{prefix};
    rmtree $dir if -d $dir;
    mkpath $dir unless -e $dir;

    return $dir;
}

sub use_remote_cache { shift->{cache} }

1;
