package Crenv;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use File::Path qw/rmtree mkpath/;
use JSON::PP;

use Crenv::Utils;
use Crenv::GitHub;

sub new {
    my ($class, %opt) = @_;

    my $self = +{ %opt };
    bless $self => $class;
}

sub install {
    my ($self, $v, $mirror) = @_;

    my ($platform, $arch) = $self->system_info;

    my $version      = $self->normalize_version($v);
    my $cache_dir    = "$self->{cache_dir}/$version";
    my $target_name  = "crystal-$version-$platform-$arch";
    my $tarball_path = "$cache_dir/$target_name.tar.gz";

    say "resolve: $target_name";
    my $tarball_url = $self->resolve($mirror, $version, $platform, $arch);

    # clean
    $self->clean($version);
    mkpath $cache_dir;

    say "fetch: $tarball_url";
    $self->{fetcher}->download($tarball_url, $tarball_path)
        or error_and_exit("download faild: $tarball_url");

    Crenv::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = glob "$cache_dir/crystal-*/";
    rmtree $self->get_install_dir if -d $self->get_install_dir;
    rename $target_dir, $self->get_install_dir or die "Error: $!";

    say 'Install successful';
}

sub show_definitions {
    my $self = shift;
    say $_ for @{ Crenv::Utils::sort_version([ $self->avaiable_versions ]) };
}

sub avaiable_versions {
    my $self = shift;

    my $releases        = $self->github->fetch_releases;
    my @tag_names       = map { $_->{tag_name} } @$releases;
    my @versions        = map { $self->normalize_version($_) } @tag_names;

    return @versions;
}

sub system_info {
    my $self = shift;

    my ($platform, $arch) = Crenv::Utils::system_info();

    if ($arch ne 'x64') {
        my $p = ucfirst $platform;
        say "WARNING!! Crystal binary is not supported $arch $p OS at the moment.";
    }

    return ($platform, $arch);
}

sub resolve {
    my $self   = shift;
    my $mirror = shift;

    if ($mirror) {
        print 'resolve by mirror: ';
        my $download_url = $self->resolve_by_mirror(@_);
        say defined $download_url ? 'found' : 'not found';
        return $download_url if defined $download_url;
    }

    {
        print 'resolve by GitHub: ';
        my $download_url = $self->resolve_by_github(@_);
        say defined $download_url ? 'found' : 'not found';
        return $download_url if defined $download_url;
    }

    error_and_exit('version not found');
    return;
}

sub resolve_by_mirror {
    my ($self, $version, $platform, $arch) = @_;

    my $response  = $self->{fetcher}->fetch($self->{mirror_url});
    my $releases  = decode_json($response);
    my ($release) = grep { $_->{tag_name} eq $version } @$releases;

    return unless defined $release;
    return $release->{assets}->{"$platform-$arch"}
}

sub resolve_by_github {
    my ($self, $version, $platform) = @_;

    my $release       = $self->github->fetch_release($version);
    my $download_urls = $self->find_binary_download_urls($release->{assets});

    return $download_urls->{$platform};
}

sub find_binary_download_urls {
    my ($self, $assets) = @_;

    my ($linux)  = grep { $_->{name} =~ /linux/  } @$assets;
    my ($darwin) = grep { $_->{name} =~ /darwin/ } @$assets;

    +{
        linux  => $linux->{browser_download_url},
        darwin => $darwin->{browser_download_url},
    };
}

sub get_install_dir {
    my $self = shift;

    my $dir = $self->{prefix};
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
    rmtree "$self->{cache_dir}/$version";
}

sub github {
    my $self = shift;

    Crenv::GitHub->new(
        fetcher     => $self->{fetcher},
        github_repo => $self->{github_repo},
    );
}

1;
