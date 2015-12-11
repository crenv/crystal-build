use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::Cache::Remote;

subtest basic => sub {
    my $guard = mock_guard(
        'CrystalBuild::Resolver::Cache::Remote', {
            _fetch => sub {
                return [
                    { tag_name => '0.7.0' },
                    { tag_name => '0.7.1' },
                    { tag_name => '0.7.2' },
                ];
            },
        });

    my $resolver = CrystalBuild::Resolver::Cache::Remote->new;

    cmp_deeply
        $resolver->versions,
        [ '0.7.0', '0.7.1', '0.7.2' ];

    is $guard->call_count('CrystalBuild::Resolver::Cache::Remote', '_fetch'), 1;
};

done_testing;
