use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Fetcher::Curl;

create_server;

subtest normal => sub {
    my $self = Crenv::Fetcher::Curl->new;
    ok $self->fetch(uri_for('test.txt')) =~ /test\s*/
};

done_testing;
