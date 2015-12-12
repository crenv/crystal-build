use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Fetcher::Wget;

subtest basic => sub {
    my $self = CrystalBuild::Fetcher::Wget->new;
    isa_ok $self, 'CrystalBuild::Fetcher::Wget';
};

done_testing;
