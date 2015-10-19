use strict;
use warnings;
use utf8;

use t::Util;
use Crenv::Utils;

sub cmp_version { Crenv::Utils::cmp_version(@_) }

subtest basic => sub {
    cmp_ok cmp_version('0.8.0',  '0.7.0'),  '>', 0;
    cmp_ok cmp_version('0.10.0', '0.7.0'),  '>', 0;
    cmp_ok cmp_version('0.12.0', '0.10.0'), '>', 0;

    cmp_ok cmp_version('0.7.1', '0.7.0'), '>',  0;
    cmp_ok cmp_version('0.7.0', '0.7.1'), '<',  0;
    cmp_ok cmp_version('0.7.0', '0.7.0'), '==', 0;
};

done_testing;
