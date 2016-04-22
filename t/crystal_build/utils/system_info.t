use strict;
use warnings;
use utf8;

use Mac::OSVersion::Lite;
use Test::Mock::Guard qw/mock_guard/;

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
        my $guard_posix = mock_guard('POSIX', {
            uname => sub { ('Darwin', undef, undef, undef, 'x86_64') },
        });

        my $guard_osx = mock_guard('Mac::OSVersion::Lite', {
            new => do { my $v = Mac::OSVersion::Lite->new('10.11'); sub { $v } },
        });

        my @system_info = CrystalBuild::Utils::system_info;
        is $system_info[0], 'darwin';
        is $system_info[2], 'el_capitan';

        is $guard_posix->call_count('POSIX', 'uname'), 1;
        is $guard_osx->call_count('Mac::OSVersion::Lite', 'new'), 1;
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
