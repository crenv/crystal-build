package CrystalBuild::Utils;
use strict;
use warnings;
use utf8;

use POSIX;
use File::Copy;
use Getopt::Long qw/:config posix_default no_ignore_case gnu_compat/;

use SemVer::V2::Strict;
use Mac::OSVersion::Lite;

sub system_info {
    my $arch;
    my $version;
    my ($sysname, $machine) = (POSIX::uname)[0, 4];

    # Linux/Darwin --- x86_64
    # FreeBSD      --- amd64
    if  ($machine =~ m/x86_64|amd64/) {
        $arch = 'x64';
    } elsif ($machine =~ m/i\d86/) {
        $arch = 'x86';
    } else {
        die "Error: $sysname $machine is not supported."
    }

    if ($sysname =~ m/\ADarwin/i) {
        eval { $version = Mac::OSVersion::Lite->new->name };
    }

    return (lc $sysname, $arch, $version);
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
        `tar xfz $filepath`;
    }

    chdir($cwd);
}

sub parse_args {
    my ($version, $prefix) = @_[-2,-1];
    my $definitions = 0;
    my $cache       = 1;

    GetOptions(
        definitions => \$definitions,
        'cache!'    => \$cache,
    );

    return {
        version     => $version,
        prefix      => $prefix,
        definitions => $definitions,
        cache       => $cache,
    };
}

sub error_and_exit {
    my $msg = shift;

    print "$msg\n";
    exit 1;
}

sub copy_force {
    my ($src_path, $dest_path) = @_;

    unlink $dest_path if -f $dest_path;
    copy $src_path, $dest_path;
}

1;
