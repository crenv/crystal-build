use strict;
use warnings;
use utf8;

use File::Path qw/mkpath/;

use t::Util;

subtest default => sub {
    my $guard = mock_guard('Crenv', { normalize_version => sub { $_[1] } });
    my $crenv = create_crenv;

    is $crenv->find_install_version('0.7.4'), '0.7.4';
    is $guard->call_count('Crenv', 'normalize_version'), 1;
};

subtest installed => sub {
    my $guard = mock_guard('Crenv', { error_and_exit => sub { die } });
    my $crenv = create_crenv;

    mkpath 't/tmp/.crenv/versions/0.7.4';
    ok -d 't/tmp/.crenv/versions/0.7.4';

    dies_ok { $crenv->find_install_version('0.7.4') };
    is $guard->call_count('Crenv', 'error_and_exit'), 1;
};

subtest failed => sub {
    my $guard = mock_guard('Crenv', { error_and_exit => sub { die } });
    my $crenv = create_crenv;

    dies_ok { $crenv->find_install_version };
    is $guard->call_count('Crenv', 'error_and_exit'), 1;
};

done_testing;
