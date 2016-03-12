use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::Crystal::RemoteCache;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Crystal::RemoteCache->new;
    $resolver->{cache_url} = 'cache_url';

    can_ok $resolver, qw/cache_url/;
    is $resolver->cache_url, 'cache_url';
};

done_testing;
