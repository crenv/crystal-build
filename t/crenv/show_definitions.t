use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture_stdout/;

use t::Util;

subtest show_definitions => sub {
    my $guard = mock_guard('Crenv', {
        avaiable_versions => sub {
            return [ '0.7.0', '0.5.0', '0.6.1' ];
        },
    });

    my $crenv = create_crenv;

    my ($stdout) = capture_stdout { $crenv->show_definitions };
    is $stdout, "0.5.0\n0.6.1\n0.7.0\n";
};

done_testing;
