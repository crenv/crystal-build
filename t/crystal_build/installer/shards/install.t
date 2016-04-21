use strict;
use warnings FATAL => 'all';
use utf8;

use File::Path qw/mkpath/;
use File::Temp qw/tempdir/;
use File::Touch;
use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;
use Capture::Tiny qw/capture_stdout/;

use t::Util;
use CrystalBuild::Installer::Shards;

use constant CRYSTAL_VERSION => '0.15.0';
use constant CRYSTAL_DIR     => '/home/user/.crenv/versions/0.15.0';
use constant EXTRACTED_DIR   => '/home/user/.crenv/cache/0.15.0/shards-0.6.2';
use constant SHARDS_BIN      => '/home/user/.crenv/cache/0.15.0/shards-0.6.2/bin/shards';
use constant TARBALL_URL     =>
    'https://github.com/crystal-lang/shards/releases/download/v0.6.2/shards-0.6.2_linux_x86_64.gz';

subtest normal => sub {
    my $installer = bless {} => 'CrystalBuild::Installer::Shards';

    my $guard = mock_guard($installer, {
        _resolve  => sub {
            is $_[1], CRYSTAL_VERSION;
            return TARBALL_URL;
        },
        _download => sub {
            is $_[1], TARBALL_URL;
            is $_[2], CRYSTAL_VERSION;
            return EXTRACTED_DIR;
        },
        _build    => sub {
            is $_[1], EXTRACTED_DIR;
            is $_[2], CRYSTAL_DIR;
            return SHARDS_BIN;
        },
        _copy     => sub {
            is $_[1], SHARDS_BIN;
            is $_[2], CRYSTAL_DIR.'/bin/shards';
        },
    });

    my ($actual) = capture_stdout {
        $installer->install(CRYSTAL_VERSION, CRYSTAL_DIR);
    };

    my $expected = <<EOF;
Checking if Shards already exists ... ng
Resolving Shards download URL ... ok
Downloading Shards tarball ...
@{[TARBALL_URL]}
ok
Building Shards ... ok
Copying Shards binary ... ok
EOF

    is $actual, $expected;

    is $guard->call_count($installer, '_resolve'), 1;
    is $guard->call_count($installer, '_download'), 1;
    is $guard->call_count($installer, '_build'), 1;
    is $guard->call_count($installer, '_copy'), 1;
};

subtest exists => sub {
    my $crystal_dir     = tempdir();
    my $crystal_bin_dir = File::Spec->catfile($crystal_dir, 'bin');
    my $shards_bin      = File::Spec->catfile($crystal_bin_dir, 'shards');

    mkpath $crystal_bin_dir;
    touch $shards_bin;
    chmod 755, $shards_bin;

    my $installer = bless {} => 'CrystalBuild::Installer::Shards';
    my ($actual) = capture_stdout {
        $installer->install(CRYSTAL_VERSION, $crystal_dir);
    };

    my $expected = <<EOF;
Checking if Shards already exists ... ok
EOF

    is $actual, $expected;
};

done_testing;
