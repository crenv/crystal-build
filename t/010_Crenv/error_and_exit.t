use strict;
use warnings;
use utf8;

BEGIN {
    *CORE::GLOBAL::exit = sub { };
};

use t::Util;
use Crenv;

subtest basic => sub {
    my ($stdout, $stderr) = capture sub {
        Crenv::error_and_exit('error_message');
    };

    ok $stdout =~ /error_message/;
};

done_testing;
