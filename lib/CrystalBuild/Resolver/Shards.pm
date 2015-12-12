package CrystalBuild::Resolver::Shards;
use strict;
use warnings;
use utf8;

use JSON::PP qw/decode_json/;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub fetcher    { shift->{fetcher}   }
sub shards_url { shift->{shards_url} }

sub resolve {
    my ($self, $crystal_version) = @_;

    my $shards_releases = $self->_fetch;
    return unless ref($shards_releases) eq 'HASH';

    return $shards_releases->{default}
        unless defined $shards_releases->{$crystal_version};

    my $tarball_url = $shards_releases->{$crystal_version};
    return if ref $tarball_url;

    return $tarball_url;
}

sub _fetch {
    my $self     = shift;
    my $response = $self->fetcher->fetch($self->shards_url);
    return decode_json($response);
}

1;
