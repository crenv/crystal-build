use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Shards;
use CrystalBuild::Resolver::Shards;

subtest basic => sub {
    my $fetcher    = Test::MockObject->new;
    my $shards_url = Test::MockObject->new;
    my $resolver   = Test::MockObject->new;

    $resolver->mock(resolve => sub {
        my ($self, $crystal_version) = @_;

        is $crystal_version, '0.9.1';
    });

    my $guard = mock_guard('CrystalBuild::Resolver::Shards', {
        new => sub {
            my ($class, %opt) = @_;

            is $opt{fetcher},    $fetcher;
            is $opt{shards_url}, $shards_url;

            return $resolver;
        },
    });

    my $installer  = CrystalBuild::Installer::Shards->new(
        fetcher    => $fetcher,
        shards_url => $shards_url,
    );
    $installer->_resolve('0.9.1');

    is $guard->call_count('CrystalBuild::Resolver::Shards', 'new'), 1;
    ok $resolver->called('resolve');
};

done_testing;
