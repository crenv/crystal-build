use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Utils;
use CrystalBuild::Installer::Crystal;

subtest basic => sub {
    my $resolver = Test::MockObject->new;
    $resolver->mock(versions => sub { [ 'v0.13.0', '0.12.1', '0.12.0' ] });

    my $installer = bless {} => 'CrystalBuild::Installer::Crystal';
    $installer->{resolver} = $resolver;

    cmp_deeply $installer->versions, [qw/0.12.0 0.12.1 0.13.0/];
};

done_testing;
