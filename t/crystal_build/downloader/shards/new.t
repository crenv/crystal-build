use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Shards;

subtest basic => sub {
    my $self = CrystalBuild::Downloader::Shards->new(fetcher => 'fetcher');

    isa_ok $self, 'CrystalBuild::Downloader::Shards';

    is $self->{fetcher}, 'fetcher';
    is $self->{fetcher}, $self->fetcher;
};

done_testing;
