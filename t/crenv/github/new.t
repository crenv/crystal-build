use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::GitHub;

subtest basic => sub {
    my $self = Crenv::GitHub->new(test_key => 'test_value');

    isa_ok $self, 'Crenv::GitHub';
    is $self->{test_key}, 'test_value';
};

done_testing;
