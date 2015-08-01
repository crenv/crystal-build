use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Resolver::Cache::Remote;

subtest basic => sub {
    my $resolver = Crenv::Resolver::Cache::Remote->new;
    $resolver->{fetcher} = 'fetcher';

    can_ok $resolver, qw/fetcher/;
    is $resolver->fetcher, 'fetcher';
};

done_testing;
