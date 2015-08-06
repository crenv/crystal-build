use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use Crenv::Resolver::Cache::Remote;

subtest basic => sub {
    my $guard = mock_guard(
        'Crenv::Resolver::Cache::Remote', {
            _fetch => sub {
                return [
                    { tag_name => '0.7.0' },
                    { tag_name => '0.7.1' },
                    { tag_name => '0.7.2' },
                ];
            },
        });

    my $resolver = Crenv::Resolver::Cache::Remote->new;

    cmp_deeply
        $resolver->versions,
        [ '0.7.0', '0.7.1', '0.7.2' ];

    is $guard->call_count('Crenv::Resolver::Cache::Remote', '_fetch'), 1;
};

done_testing;
