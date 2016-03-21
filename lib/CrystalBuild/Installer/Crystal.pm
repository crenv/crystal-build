package CrystalBuild::Installer::Crystal;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use File::Path qw/mkpath rmtree/; # => 5.001

use CrystalBuild::Utils;
use CrystalBuild::Downloader::Crystal;
use CrystalBuild::Resolver::Utils;
use CrystalBuild::Resolver::Crystal;

sub new {
    my ($class, %opt) = @_;
    my $self = bless {} => $class;

    $self->{fetcher}   = $opt{fetcher};
    $self->{cache_dir} = $opt{cache_dir};
    $self->{resolver}  = $self->_create_resolver(%opt);

    return $self;
}

sub install {
    my ($self, $crystal_version, $install_dir) = @_;

    eval {
        my $tarball_url = $self->_resolve($crystal_version);

        say "Downloading Crystal binary tarball ...";
        say "$tarball_url";
        my $extracted_dir = $self->_download($crystal_version, $tarball_url);
        say "ok";

        print "Moving the Crystal directory ...";
        $self->_move($extracted_dir, $install_dir);
        print "ok\n";
    };

    CrystalBuild::Utils::error_and_exit($@) if $@;
}

sub versions {
    my $self     = shift;
    my $versions = eval { $self->{resolver}->versions };

    CrystalBuild::Utils::error_and_exit('avaiable versions not found') if $@;

    my @normalized_versions = grep { CrystalBuild::Resolver::Utils->normalize_version($_) } @$versions;
    my $sorted_versions     = CrystalBuild::Resolver::Utils->sort_version(\@normalized_versions);

    return $sorted_versions;
}

sub needs_shards {
    my ($self, $version) = @_;
    my $v077 = SemVer::V2::Strict->new('0.7.7');
    return SemVer::V2::Strict->new($version) >= $v077; # >= v0.7.7
}

sub _resolve {
    my ($self, $crystal_version) = @_;
    return $self->{resolver}->resolve_by_version($crystal_version);
}

sub _download {
    my ($self, $crystal_version, $tarball_url) = @_;
    my $cache_dir = "$self->{cache_dir}/$crystal_version";
    return CrystalBuild::Downloader::Crystal->new(
        fetcher => $self->{fetcher},
    )->download($tarball_url, $cache_dir);
}

sub _move {
    my ($self, $extracted_dir, $install_dir) = @_;
    mkpath $install_dir unless -e $install_dir;
    rmtree $install_dir if -e $install_dir;
    rename $extracted_dir, $install_dir
        or die "faild to move the Crystal directory $!";
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
