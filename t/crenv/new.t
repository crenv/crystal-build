use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild;

subtest basic => sub {
    my $crenv = CrystalBuild->new(test_key => 'test_value');

    isa_ok $crenv, 'CrystalBuild';
    is $crenv->{test_key}, 'test_value';
};

done_testing;
