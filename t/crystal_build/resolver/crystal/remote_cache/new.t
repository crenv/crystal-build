use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::Crystal::RemoteCache;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Crystal::RemoteCache->new(test_key => 'test_value');

    isa_ok $resolver, 'CrystalBuild::Resolver::Crystal::RemoteCache';
    is $resolver->{test_key}, 'test_value';
};

done_testing;
