package CrystalBuild::Resolver::Crystal::GitHub;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub name { 'GitHub' }

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    my $release       = $self->github->fetch_release($version);
    my %download_urls = $self->_find_binary_download_urls($release->{assets});

    return $download_urls{"$platform-$arch"};
}

sub versions {
    my $self = shift;

    my $releases = $self->github->fetch_releases;
    my @tags     = map { $_->{tag_name} } @$releases;

    return \@tags;
}

sub github { shift->{github} }

sub _find_binary_download_urls {
    my ($self, $assets) = @_;

    my ($linux_x64) = grep { $_->{name} =~ /linux.*64/   } @$assets;
    my ($linux_x86) = grep { $_->{name} =~ /linux.*i686/ } @$assets;
    my ($darwin)    = grep { $_->{name} =~ /darwin/      } @$assets;

    my %download_urls;
    $download_urls{'linux-x64'}  = $linux_x64->{browser_download_url} if defined $linux_x64;
    $download_urls{'linux-x86'}  = $linux_x86->{browser_download_url} if defined $linux_x86;
    $download_urls{'darwin-x64'} = $darwin->{browser_download_url}    if defined $darwin;

    return %download_urls;
}

1;
