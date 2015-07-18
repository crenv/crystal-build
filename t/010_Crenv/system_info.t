use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture/;

use t::Util;
use Crenv;

subtest default => sub {
    my $guard = mock_guard('Crenv::Utils', {
        system_info => sub { ('linux', 'x64') }
    });

    my $crenv = create_crenv;
    cmp_deeply [ $crenv->system_info ], [ 'linux', 'x64' ];
};

subtest error => sub {
    my $guard = mock_guard('Crenv::Utils', {
        system_info => sub { ('linux', 'x86') }
    });

    my $crenv = create_crenv;

    my ($stdout, $stderr) = capture { $crenv->system_info };
    ok $stdout =~ /not supported/;
};

done_testing;
