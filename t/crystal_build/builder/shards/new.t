use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;

use CrystalBuild::Builder::Shards;

subtest basic => sub {
    my $without_release = Test::MockObject->new;

    my $self = CrystalBuild::Builder::Shards->new(
        without_release  => $without_release,
    );

    isa_ok $self, 'CrystalBuild::Builder::Shards';

    is $self->without_release, $without_release;
};

done_testing;
