use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Shards;

subtest basic => sub {
    my $fetcher          = Test::MockObject->new;
    my $remote_cache_url = Test::MockObject->new;
    my $cache_dir        = Test::MockObject->new;

    my $installer = CrystalBuild::Installer::Shards->new(
        fetcher          => $fetcher,
        remote_cache_url => $remote_cache_url,
        cache_dir        => $cache_dir,
    );

    isa_ok $installer, 'CrystalBuild::Installer::Shards';

    is $installer->fetcher,          $fetcher;
    is $installer->remote_cache_url, $remote_cache_url;
    is $installer->cache_dir,        $cache_dir;
};

done_testing;
