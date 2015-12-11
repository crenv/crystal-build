use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $self = CrystalBuild::Builder::Shards->new;
    isa_ok $self, 'CrystalBuild::Builder::Shards';
};

done_testing;
