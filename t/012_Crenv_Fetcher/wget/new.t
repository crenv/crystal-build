use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Fetcher::Wget;

subtest basic => sub {
    my $self = Crenv::Fetcher::Wget->new;
    isa_ok $self, 'Crenv::Fetcher::Wget';
};

done_testing;
