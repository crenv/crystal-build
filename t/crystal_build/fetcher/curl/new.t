use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Fetcher::Curl;

subtest basic => sub {
    my $self = CrystalBuild::Fetcher::Curl->new;
    isa_ok $self, 'CrystalBuild::Fetcher::Curl';
};

done_testing;
