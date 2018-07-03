use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;

use CrystalBuild;

subtest basic => sub {
    my $without_release = Test::MockObject->new;

    my $crenv = CrystalBuild->new(
        test_key        => 'test_value',
        without_release => $without_release,
    );

    isa_ok $crenv, 'CrystalBuild';

    is $crenv->{test_key},        'test_value';
    is $crenv->{without_release}, $without_release;
};

done_testing;
