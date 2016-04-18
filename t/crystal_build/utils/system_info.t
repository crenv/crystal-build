use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Utils;

subtest normal => sub {
    subtest '# Linux' => sub {
        my $guard = mock_guard('POSIX', {
            uname => sub { ('Linux', undef, undef, undef, 'x86_64') },
        });

        my @system_info = CrystalBuild::Utils::system_info;
        is $system_info[0], 'linux';
    };

    subtest '# Darwin' => sub {
        my $guard = mock_guard('POSIX', {
            uname => sub { ('Darwin', undef, undef, undef, 'x86_64') },
        });

        my @system_info = CrystalBuild::Utils::system_info;
        is $system_info[0], 'darwin';
    };

    subtest '# x64' => sub {
        my $guard = mock_guard('POSIX', {
            uname => sub { ('Linux', undef, undef, undef, 'x86_64') },
        });

        my @system_info = CrystalBuild::Utils::system_info;
        is $system_info[1], 'x64';
    };

    subtest '# x86' => sub {
        my $guard = mock_guard('POSIX', {
            uname => sub { ('Linux', undef, undef, undef, 'i686') },
        });

        my @system_info = CrystalBuild::Utils::system_info;
        is $system_info[1], 'x86';
    };
};

subtest anomaly => sub {
    my $guard = mock_guard('POSIX', {
        uname => sub { ('Linux', undef, undef, undef, 'unknown') },
    });

    dies_ok { CrystalBuild::Utils::system_info };
};

done_testing;
