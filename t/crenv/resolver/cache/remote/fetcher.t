use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::Cache::Remote;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Cache::Remote->new;
    $resolver->{fetcher} = 'fetcher';

    can_ok $resolver, qw/fetcher/;
    is $resolver->fetcher, 'fetcher';
};

done_testing;
