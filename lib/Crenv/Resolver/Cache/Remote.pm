package Crenv::Resolver::Cache::Remote;
use strict;
use warnings;
use utf8;

use JSON::PP;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub fetcher   { shift->{fetcher}   }
sub cache_url { shift->{cache_url} }

sub resolve {
    my ($self, $version, $platform, $arch) = @_;

    my $response  = $self->fetcher->fetch($self->cache_url);
    my $releases  = decode_json($response);
    my ($release) = grep { $_->{tag_name} eq $version } @$releases;

    return unless defined $release;
    return $release->{assets}->{"$platform-$arch"}
}

1;
