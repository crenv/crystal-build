use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $env_crystal_path = '__ENV_CRYSTAL_PATH__';
    my $target_dir       = '__TARGET_DIR__';
    my $crystal_bin      = '__CRYSTAL_BIN__';

    my $builder  = CrystalBuild::Builder::Shards->new;
    my $actual   = $builder->_create_build_command($env_crystal_path, $target_dir, $crystal_bin);
    my $expected = <<'EOF';
CRYSTAL_PATH=__ENV_CRYSTAL_PATH__ \
LD_LIBRARY_PATH=__TARGET_DIR__:$LD_LIBRARY_PATH \
cd "__TARGET_DIR__" && "__CRYSTAL_BIN__" build --release src/shards.cr -o bin/shards
EOF

    is $actual, $expected;
};

done_testing;
