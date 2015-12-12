use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::Cache::Remote;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Cache::Remote->new(test_key => 'test_value');

    isa_ok $resolver, 'CrystalBuild::Resolver::Cache::Remote';
    is $resolver->{test_key}, 'test_value';
};

done_testing;
