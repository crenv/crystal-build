use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use Crenv;

subtest basic => sub {
    my $resolver = Test::MockObject->new;
    $resolver->mock(versions => sub {
        return [ '0.6.0', '0.6.1', '0.6.2' ];
    });

    my $guard = mock_guard('Crenv', {
       resolvers => sub {
           return [ [ 'test', $resolver ] ];
       },
    });

    my $crenv = create_crenv;

    cmp_deeply
        $crenv->versions,
        [ '0.6.0', '0.6.1', '0.6.2' ];

    is $guard->call_count('Crenv', 'resolvers'), 1;
    ok $resolver->called('versions');
};

done_testing;
