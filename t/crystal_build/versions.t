use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild;

subtest basic => sub {
    my $installer = Test::MockObject->new;
    $installer->mock(versions => sub {
        return [ '0.6.0', '0.6.1', '0.6.2' ];
    });

    my $guard = mock_guard('CrystalBuild', {
        crystal_installer => sub { $installer },
    });

    my $crenv = create_crenv;

    cmp_deeply
        $crenv->versions,
        [ '0.6.0', '0.6.1', '0.6.2' ];

    is $guard->call_count('CrystalBuild', 'crystal_installer'), 1;
    ok $installer->called('versions');
};

done_testing;
