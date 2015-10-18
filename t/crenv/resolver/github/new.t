use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Resolver::GitHub;

subtest basic => sub {
    my $resolver = Crenv::Resolver::GitHub->new(test_key => 'test_value');

    isa_ok $resolver, 'Crenv::Resolver::GitHub';
    is $resolver->{test_key}, 'test_value';
};

done_testing;
