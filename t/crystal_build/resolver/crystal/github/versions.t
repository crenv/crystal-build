use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::Crystal::GitHub;

subtest basic => sub {
    my $github = Test::MockObject->new;
    $github->mock(fetch_releases => sub {
        my ($self) = @_;
        return [
            { tag_name => '0.7.0' },
            { tag_name => '0.7.1' },
            { tag_name => '0.7.2' },
        ];
    });

    my $guard = mock_guard(
        'CrystalBuild::Resolver::Crystal::GitHub', {
            github => sub { $github },
        });

    my $resolver = CrystalBuild::Resolver::Crystal::GitHub->new;

    cmp_deeply
        $resolver->versions,
        [ '0.7.0', '0.7.1', '0.7.2' ];

    ok $github->called('fetch_releases');
    is $guard->call_count('CrystalBuild::Resolver::Crystal::GitHub', 'github'), 1;
};

done_testing;
