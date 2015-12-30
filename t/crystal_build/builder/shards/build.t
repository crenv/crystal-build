use strict;
use warnings;
use utf8;

my $dummy_system;;
use Test::Mock::Cmd system => sub { &$dummy_system(@_) };
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $target_dir  = '__TARGET_DIR__';
    my $crystal_dir = '__CRYSTAL_DIR__';

    my $builder = CrystalBuild::Builder::Shards->new;

    my $guard = mock_guard('CrystalBuild::Builder::Shards', {
        abs_path              => sub { shift },
        install_libyaml       => sub { is $_[1], $target_dir },
        _create_build_command => sub {
            my ($self, $env_crystal_path, $target_dir, $crystal_bin) = @_;

            is $env_crystal_path, '__CRYSTAL_DIR__/libs:.';
            is $target_dir,       '__TARGET_DIR__';
            is $crystal_bin,      '__CRYSTAL_DIR__/bin/crystal';

            return '__COMMAND__';
        },
    });

    my $dummy_system_called;
    $dummy_system = sub {
        is shift, '__COMMAND__';
        $dummy_system_called = 1;
        return 0;
    };

    is $builder->build($target_dir, $crystal_dir), '__TARGET_DIR__/bin/shards';

    is $guard->call_count('CrystalBuild::Builder::Shards', 'abs_path'), 2;
    is $guard->call_count('CrystalBuild::Builder::Shards', 'install_libyaml'), 1;
    is $guard->call_count('CrystalBuild::Builder::Shards', '_create_build_command'), 1;

    ok $dummy_system_called;
};

done_testing;
