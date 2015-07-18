use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Fetcher;

subtest wget => sub {
    my $self = Crenv::Fetcher->get('wget');
    isa_ok $self, 'Crenv::Fetcher::Wget';
};

subtest curl => sub {
    my $self = Crenv::Fetcher->get('curl');
    isa_ok $self, 'Crenv::Fetcher::Curl';
};

done_testing;
