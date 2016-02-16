use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::Crystal::GitHub;

subtest basic => sub {
    my $resolver = CrystalBuild::Resolver::Crystal::GitHub->new;
    $resolver->{github} = 'github';

    can_ok $resolver, qw/github/;
    is $resolver->github, 'github';
};

done_testing;
