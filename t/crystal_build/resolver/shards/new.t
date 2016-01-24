use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Resolver::Shards;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Shards->new(
        fetcher             => '__FETCHER__',
        shards_releases_url => '__SHARDS_RELEASES_URL__',
    );

    isa_ok $resolver, 'CrystalBuild::Resolver::Shards';

    is $resolver->fetcher,             '__FETCHER__';
    is $resolver->shards_releases_url, '__SHARDS_RELEASES_URL__';
};

done_testing;
