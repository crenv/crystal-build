package CrystalBuild::Resolver::Shards;
use strict;
use warnings;
use utf8;

use JSON::PP qw/decode_json/;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

sub fetcher             { shift->{fetcher}             }
sub shards_releases_url { shift->{shards_releases_url} }

sub resolve {
    my ($self, $crystal_version) = @_;

    my $shards_releases = $self->_fetch;
    return unless ref($shards_releases) eq 'HASH';

    if (defined $shards_releases->{$crystal_version}) {
        my $tarball_url = $shards_releases->{$crystal_version};
        return $tarball_url unless ref $tarball_url;
    }

    return $shards_releases->{default} if defined $shards_releases->{default};
    return undef;
}

sub _fetch {
    my $self     = shift;
    my $response = $self->fetcher->fetch($self->shards_releases_url);
    return decode_json($response);
}

1;
