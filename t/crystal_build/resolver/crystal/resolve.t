use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest basic => sub {
    my @mock_resolvers = map { Test::MockObject->new } 0..2;
    $mock_resolvers[0]->mock(resolve => sub { undef });
    $mock_resolvers[1]->mock(resolve => sub {
        my ($self, $version, $platform, $arch) = @_;
        is $version,  '0.13.0';
        is $platform, 'darwin';
        is $arch,     'x64';
        return '__URL1__';
    });
    $mock_resolvers[2]->mock(resolve => sub { '__URL2__' });

    my $resolver = bless {
        resolvers => \@mock_resolvers,
    } => 'CrystalBuild::Resolver::Crystal';

    is $resolver->resolve('0.13.0', 'darwin', 'x64'), '__URL1__';

    ok $mock_resolvers[0]->called('resolve');
    ok $mock_resolvers[1]->called('resolve');
    ok !$mock_resolvers[2]->called('resolve');
};

subtest failed => sub {
    my $resolver = bless { resolvers => [] } => 'CrystalBuild::Resolver::Crystal';
    dies_ok { $resolver->resolve('0.13.0', 'darwin', 'x86') };
};

done_testing;
