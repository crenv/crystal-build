package Crenv::Utils;
use strict;
use warnings;
use utf8;

use POSIX;
use Getopt::Long qw/:config posix_default no_ignore_case gnu_compat/;

sub sort_version {
    my $version = shift;

    return [sort {
        my ($a1, $a2, $a3) = ($a =~ m/(\d+)\.(\d+)\.(\d+)/);
        my ($b1, $b2, $b3) = ($b =~ m/(\d+)\.(\d+)\.(\d+)/);
        $a1 <=> $b1 || $a2 <=> $b2 || $a3 <=> $b3
    } @$version];
}

sub system_info {
    my $arch;
    my ($sysname, $machine) = (POSIX::uname)[0, 4];

    if  ($machine =~ m/x86_64/) {
        $arch = 'x64';
    } elsif ($machine =~ m/i\d86/) {
        $arch = 'x86';
    } elsif ($machine =~ m/armv6l/) {
        $arch = 'arm-pi';
    } elsif ($sysname =~ m/sunos/i) {
        # SunOS $machine => 'i86pc'. but use 64bit kernel.
        # Solaris 11 not support 32bit kernel.
        # both 32bit and 64bit node-binary even work on 64bit kernel
        $arch = 'x64';
    } else {
        die "Error: $sysname $machine is not supported."
    }

    return (lc $sysname, $arch);
}

sub extract_tar {
    my ($filepath, $outdir) = @_;

    my $cwd = getcwd;

    chdir($outdir);

    eval {
        require Archive::Tar;
        my $tar = Archive::Tar->new;
        $tar->read($filepath);
        $tar->extract;
    };
    if ($@) {
        `tar zfx $filepath`;
    }

    chdir($cwd);
}

sub parse_args {
    my ($version, $prefix) = @_[-2,-1];
    my $definitions;

    GetOptions(
        definitions => \$definitions
    );

    return {
        version     => $version,
        prefix      => $prefix,
        definitions => $definitions,
    };
}

1;
