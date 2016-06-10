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
        abs_path              => sub { $_[0] },
        tempfile              => '/tmp/tempfile',
        _create_build_script  => sub {
            is $_[1], TARGET_DIR;
            is $_[2], CRYSTAL_DIR;
            return '#!/usr/bin/env bash';
        },
        _run_script           => 1,
    });

    is $builder->build(TARGET_DIR, CRYSTAL_DIR), TARGET_DIR.'/bin/shards';

    is $guard->call_count('CrystalBuild::Builder::Shards', '_create_build_script'), 1;
    is $guard->call_count('CrystalBuild::Builder::Shards', '_run_script'), 1;
};

done_testing;
