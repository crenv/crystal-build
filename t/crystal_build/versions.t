use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild;

subtest succeeded => sub {
    my $resolver = Test::MockObject->new;
    $resolver->mock(versions => sub {
        return [ '0.6.0', '0.6.1', '0.6.2' ];
    });

    my $guard = mock_guard('CrystalBuild', {
        composite_resolver => sub { $resolver },
    });

    my $crenv = create_crenv;

    cmp_deeply
        $crenv->versions,
        [ '0.6.0', '0.6.1', '0.6.2' ];

    is $guard->call_count('CrystalBuild', 'composite_resolver'), 1;
    ok $resolver->called('versions');
};

subtest failed => sub {
    my $resolver = Test::MockObject->new;
    $resolver->mock(versions => sub { die 'error' });

    my $guard = mock_guard('CrystalBuild', {
        composite_resolver => sub { $resolver },
        error_and_exit     => sub {
            my $msg = shift;
            is $msg, 'avaiable versions not found';
        },
    });

    my $crenv = create_crenv;

    $crenv->versions,
    is $guard->call_count('CrystalBuild', 'composite_resolver'), 1;
    is $guard->call_count('CrystalBuild', 'error_and_exit'), 1;
};

done_testing;
