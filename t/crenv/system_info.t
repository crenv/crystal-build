use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture/;

use t::Util;
use Crenv;

subtest basic => sub {
    my $guard = mock_guard('Crenv::Utils', {
        system_info => sub { ('linux', 'x64') }
    });

    my $crenv = create_crenv;
    cmp_deeply [ $crenv->system_info ], [ 'linux', 'x64' ];
};

done_testing;
