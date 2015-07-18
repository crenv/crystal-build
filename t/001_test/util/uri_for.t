use strict;
use warnings;
use utf8;

use t::Util;

my $server = create_server;

subtest basic => sub {
    is uri_for('test.txt'), 'http://127.0.0.1:' . $server->port . '/test.txt';
};

done_testing;
