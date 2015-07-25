use strict;
use warnings;
use utf8;

use t::Util;

subtest basic => sub {
    isa_ok create_crenv, 'Crenv';
};

done_testing;
