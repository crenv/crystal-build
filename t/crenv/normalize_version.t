use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild;

subtest default => sub {
    my $crenv = create_crenv;
    is $crenv->normalize_version('0.7.0'), '0.7.0';
};

subtest prefix => sub {
    my $crenv = create_crenv;
    is $crenv->normalize_version('v0.7.0'), '0.7.0';
};

subtest other => sub {
    my $crenv = create_crenv;
    is $crenv->normalize_version('other'), 'other';
};

subtest failed => sub {
    my $guard = mock_guard('CrystalBuild', { error_and_exit => sub { die } });
    my $crenv = create_crenv;

    dies_ok { $crenv->normalize_version };
    is $guard->call_count('CrystalBuild', 'error_and_exit'), 1;
};

done_testing;
