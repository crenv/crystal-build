use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Builder::Shards;

subtest basic => sub {
    my $self = Crenv::Builder::Shards->new;
    isa_ok $self, 'Crenv::Builder::Shards';
};

done_testing;
