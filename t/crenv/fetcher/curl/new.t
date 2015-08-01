use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Fetcher::Curl;

subtest basic => sub {
    my $self = Crenv::Fetcher::Curl->new;
    isa_ok $self, 'Crenv::Fetcher::Curl';
};

done_testing;
