use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest basic => sub {
    my @mock_resolvers = map { Test::MockObject->new } 0..2;
    $mock_resolvers[0]->mock(versions => sub { die });
    $mock_resolvers[1]->mock(versions => sub { [ '0.13.0' ] });
    $mock_resolvers[2]->mock(versions => sub { [ '0.14.0' ] });

    my $resolver = bless {
        resolvers => \@mock_resolvers,
    } => 'CrystalBuild::Resolver::Crystal';

    is $resolver->versions->[0], '0.13.0';
};

subtest failed => sub {
    subtest '# no versions' => sub {
        my $resolver = Test::MockObject->new;
        $resolver->mock(versions => sub { [] });

        my $composite_resolver =
            bless { resolvers => [ $resolver ] } => 'CrystalBuild::Resolver::Crystal';

        dies_ok { $composite_resolver->versions };
    };

    subtest '# no resolvers' => sub {
        my $resolver = bless { resolvers => [] } => 'CrystalBuild::Resolver::Crystal';
        dies_ok { $resolver->versions };
    };
};

done_testing;
