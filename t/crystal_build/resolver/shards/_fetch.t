use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::Shards;

subtest basic => sub {
    my $url     = Test::MockObject->new;
    my $fetcher = Test::MockObject->new;
    $fetcher->mock(fetch => sub {
        is $_[1], $url;
        return do { local $/; <DATA> };
    });

    my $resolver = CrystalBuild::Resolver::Shards->new(
        fetcher             => $fetcher,
        shards_releases_url => $url,
    );

    cmp_deeply $resolver->_fetch, { result => "ok" };
    ok $fetcher->called('fetch');
};

done_testing;
__DATA__
{ "result": "ok" }
