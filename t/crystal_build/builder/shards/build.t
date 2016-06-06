use strict;
use warnings;
use utf8;

my $dummy_system;;
use Test::Mock::Cmd system => sub { &$dummy_system(@_) };
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Builder::Shards;

use constant TARGET_DIR  => '__TARGET_DIR__';
use constant CRYSTAL_DIR => '__CRYSTAL_DIR__';

subtest basic => sub {
    my $builder = CrystalBuild::Builder::Shards->new;

    my $guard = mock_guard('CrystalBuild::Builder::Shards', {
        abs_path              => sub { shift },
        _create_build_command => sub {
            my ($self, $env_crystal_path, $target_dir, $crystal_bin) = @_;

            is $env_crystal_path, CRYSTAL_DIR.'/libs:.';
            is $target_dir,       TARGET_DIR;
            is $crystal_bin,      CRYSTAL_DIR.'/bin/crystal';

            return '__COMMAND__';
        },
    });

    my $guard_libyaml = mock_guard('CrystalBuild::Builder::Shards::LibYAML', {
        install => sub {
            my ($class, $target_dir) = @_;
            is $class, 'CrystalBuild::Builder::Shards::LibYAML';
            is $target_dir, TARGET_DIR;
        },
    });

    my $dummy_system_called;
    $dummy_system = sub {
        is shift, '__COMMAND__';
        $dummy_system_called = 1;
        return 0;
    };

    is $builder->build(TARGET_DIR, CRYSTAL_DIR), TARGET_DIR.'/bin/shards';

    is $guard->call_count('CrystalBuild::Builder::Shards', 'abs_path'), 2;
    is $guard->call_count('CrystalBuild::Builder::Shards', '_create_build_command'), 1;
    is $guard_libyaml->call_count('CrystalBuild::Builder::Shards::LibYAML', 'install'), 1;

    ok $dummy_system_called;
};

done_testing;
