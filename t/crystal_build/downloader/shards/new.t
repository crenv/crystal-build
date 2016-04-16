use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Shards;

subtest basic => sub {
    my $self = CrystalBuild::Downloader::Shards->new(fetcher => '__FETCHER__');

    isa_ok $self, 'CrystalBuild::Downloader::Shards';
    is $self->{fetcher}, '__FETCHER__';
};

done_testing;
