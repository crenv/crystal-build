use strict;
use warnings;
use utf8;

use t::Util;

use Crenv;

subtest basic => sub {
    my $crenv = Crenv->new(test_key => 'test_value');

    isa_ok $crenv, 'Crenv';
    is $crenv->{test_key}, 'test_value';
};

done_testing;
