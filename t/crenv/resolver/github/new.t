use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::GitHub;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::GitHub->new(test_key => 'test_value');

    isa_ok $resolver, 'CrystalBuild::Resolver::GitHub';
    is $resolver->{test_key}, 'test_value';
};

done_testing;
