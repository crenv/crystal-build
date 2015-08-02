use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Resolver::GitHub;

subtest basic => sub {
    my $resolver = Crenv::Resolver::GitHub->new;
    $resolver->{github} = 'github';

    can_ok $resolver, qw/github/;
    is $resolver->github, 'github';
};

done_testing;
