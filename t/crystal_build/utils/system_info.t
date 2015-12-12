use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Utils;

    # if  ($machine =~ m/x86_64/) {
    #     $arch = 'x64';
    # } elsif ($machine =~ m/i\d86/) {
    #     $arch = 'x86';
    # } elsif ($machine =~ m/armv6l/) {
    #     $arch = 'arm-pi';
    # } elsif ($sysname =~ m/sunos/i) {
    #     # SunOS $machine => 'i86pc'. but use 64bit kernel.
    #     # Solaris 11 not support 32bit kernel.
    #     # both 32bit and 64bit node-binary even work on 64bit kernel
    #     $arch = 'x64';
    # } else {
    #     die "Error: $sysname $machine is not supported."
    # }

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
