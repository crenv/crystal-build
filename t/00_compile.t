use strict;
use warnings;
use utf8;

use t::Util;
use Module::Find;

subtest basic => sub {
    lives_ok { useall 'CrystalBuild' };
};

done_testing;
