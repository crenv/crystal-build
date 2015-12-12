use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Shards;
use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $builder = Test::MockObject->new;

    $builder->mock(build => sub {
        my ($self, $target_dir, $crystal_dir) = @_;

        is $target_dir,  'target_dir';
        is $crystal_dir, 'crystal_dir';
    });

    my $guard = mock_guard('CrystalBuild::Builder::Shards', {
        new => $builder,
    });

    my $installer  = CrystalBuild::Installer::Shards->new;
    $installer->_build('target_dir', 'crystal_dir');

    is $guard->call_count('CrystalBuild::Builder::Shards', 'new'), 1;
    ok $builder->called('build');
};

done_testing;
