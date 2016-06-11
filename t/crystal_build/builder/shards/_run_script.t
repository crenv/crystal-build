use CrystalBuild::Sense;

use t::Util;
use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $builder = CrystalBuild::Builder::Shards->new;

    ok $builder->_run_script("#/usr/bin/env bash\nexit 0");
    ok !$builder->_run_script("#/usr/bin/env bash\nexit 1");
};

done_testing;
