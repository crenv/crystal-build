package Crenv;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use File::Path qw/rmtree mkpath/;

use Crenv::Utils;
use Crenv::GitHub;

sub new {
    my ($class, %opt) = @_;

    my $self = +{ %opt };
    bless $self => $class;

    $self->init;
    $self;
}

sub init {
    my $self = shift;

    $self->{versions_dir} = $self->{prefix} . '/versions';
    $self->{cache_dir}    = $self->{prefix} . '/cache';
}

sub install {
    my ($self, $v) = @_;

    my ($platform, $arch) = Crenv::Utils::system_info();

    if ($arch ne 'x64') {
        my $p = ucfirst $platform;
        say "WARNING!! Crystal binary is not supported $arch $p OS at the moment.";
    }

    my $version      = $self->find_install_version($v);
    my $cache_dir    = "$self->{cache_dir}/$version";
    my $target_name  = "crystal-$version-$platform-$arch";
    my $tarball_path = "$cache_dir/$target_name.tar.gz";

    say "resolve: $target_name";
    my $release       = $self->github->fetch_release($version);
    my $download_urls = $self->find_binary_download_urls($release->{assets});

    error_and_exit('version not found') unless defined $download_urls->{$platform};

    my $tarball_url = $download_urls->{$platform};

    # clean
    $self->clean($version);
    mkpath $cache_dir;

    say "fetch: $tarball_url";
    $self->{fetcher}->download($tarball_url, $tarball_path)
        or error_and_exit("download faild: $tarball_url");

    Crenv::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = glob "$cache_dir/crystal-*/";
    rename $target_dir, $self->get_install_dir . "/$version" or die "Error: $!";

    say 'Install successful';
}

sub show_definitions {
    my ($self) = @_;

    my $releases        = $self->github->fetch_releases;
    my @tag_names       = map { $_->{tag_name} } @$releases;
    my @versions        = map { $self->normalize_version($_) } @tag_names;
    my $sorted_versions = Crenv::Utils::sort_version(\@versions);

    say $_ for @$sorted_versions;
}

sub find_install_version {
    my ($self, $v) = @_;

    my $version = $self->normalize_version($v);

    error_and_exit('version not found') unless $version;
    error_and_exit("$version is already installed")
        if -e $self->get_install_dir . "/$version";

    return $version;
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

    my $dir = $self->{versions_dir};
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

    if ($version eq 'all') {
        opendir my $dh, $self->{cache_dir} or return;
        while (my $file = readdir $dh) {
            next if $file =~ m/^\./;
            my $path = "$self->{cache_dir}/$file";
            unlink $path if -f $path;
            rmtree $path if -d $path;
        }
    }
    elsif (-d "$self->{cache_dir}/$version") {
        rmtree "$self->{cache_dir}/$version";
    }
}

sub github {
    my $self = shift;

    Crenv::GitHub->new(
        fetcher     => $self->{fetcher},
        github_repo => $self->{github_repo},
    );
}

1;
