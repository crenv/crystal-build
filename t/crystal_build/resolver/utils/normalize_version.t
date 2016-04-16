use strict;
use warnings FATAL => 'all';
use utf8;

use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Utils;

sub normalize_version { CrystalBuild::Resolver::Utils->normalize_version(@_) }

subtest default => sub {
    is normalize_version('0.7.0'), '0.7.0';
};

subtest prefix => sub {
    is normalize_version('v0.7.0'), '0.7.0';
};

subtest other => sub {
    is normalize_version('other'), 'other';
};

subtest failed => sub {
    dies_ok { normalize_version };
};

done_testing;
