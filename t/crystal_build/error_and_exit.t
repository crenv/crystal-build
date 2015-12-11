use strict;
use warnings;
use utf8;

BEGIN {
    *CORE::GLOBAL::exit = sub { };
};

use Capture::Tiny ':all';

use t::Util;
use CrystalBuild;

subtest basic => sub {
    my ($stdout, $stderr) = capture sub {
        CrystalBuild::error_and_exit('error_message');
    };

    ok $stdout =~ /error_message/;
};

done_testing;
