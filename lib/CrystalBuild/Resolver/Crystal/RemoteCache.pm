package CrystalBuild::Resolver::Crystal::RemoteCache;
use strict;
use warnings;
use utf8;

use JSON::PP;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub name { 'Remote Cache' }

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    my ($release) = grep { $_->{tag_name} eq $version } @{ $self->_fetch };
    return unless defined $release;
    return $release->{assets}->{"$platform-$arch"}
}

sub versions {
    my $self = shift;

    my @versions = map { $_->{tag_name} } @{ $self->_fetch };
    return \@versions;
}

sub _fetch {
    my $self     = shift;
    my $response = $self->fetcher->fetch($self->cache_url);
    return decode_json($response);
}

sub fetcher   { shift->{fetcher}   }
sub cache_url { shift->{cache_url} }

1;
