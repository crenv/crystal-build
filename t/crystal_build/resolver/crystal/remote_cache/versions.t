use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::Crystal::RemoteCache;

subtest basic => sub {
    my $guard = mock_guard(
        'CrystalBuild::Resolver::Crystal::RemoteCache', {
            _fetch => sub {
                return [
                    { tag_name => '0.7.0' },
                    { tag_name => '0.7.1' },
                    { tag_name => '0.7.2' },
                ];
            },
        });

    my $resolver = CrystalBuild::Resolver::Crystal::RemoteCache->new;

    cmp_deeply
        $resolver->versions,
        [ '0.7.0', '0.7.1', '0.7.2' ];

    is $guard->call_count('CrystalBuild::Resolver::Crystal::RemoteCache', '_fetch'), 1;
};

done_testing;
