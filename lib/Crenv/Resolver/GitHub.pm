package Crenv::Resolver::GitHub;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    my $release       = $self->github->fetch_release($version);
    my $download_urls = $self->find_binary_download_urls($release->{assets});

    return $download_urls->{"$platform-$arch"};
}

sub github { shift->{github} }

sub find_binary_download_urls {
    my ($self, $assets) = @_;

    my ($linux)  = grep { $_->{name} =~ /linux/  } @$assets;
    my ($darwin) = grep { $_->{name} =~ /darwin/ } @$assets;

    return {
        'linux-x64'  => $linux->{browser_download_url},
        'darwin-x64' => $darwin->{browser_download_url},
    };
}

1;
