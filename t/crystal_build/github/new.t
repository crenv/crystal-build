use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::GitHub;

subtest basic => sub {
    my $self = CrystalBuild::GitHub->new(test_key => 'test_value');

    isa_ok $self, 'CrystalBuild::GitHub';
    is $self->{test_key}, 'test_value';
};

done_testing;
