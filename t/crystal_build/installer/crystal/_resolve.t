use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Installer::Crystal;

subtest basic => sub {
    my $resolver = Test::MockObject->new;
    $resolver->mock(resolve_by_version => sub {
        my ($self, $version) = @_;
        is $version, '0.13.0';
    });

    my $installer = bless {} => 'CrystalBuild::Installer::Crystal';
    $installer->{resolver} = $resolver;

    $installer->_resolve('0.13.0');

    ok !$resolver->called('resolve');
    ok $resolver->called('resolve_by_version');
};

done_testing;
