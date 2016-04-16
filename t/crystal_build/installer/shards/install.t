use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;
use Capture::Tiny qw/capture_stdout/;

use t::Util;
use CrystalBuild::Installer::Shards;

subtest basic => sub {
    my $installer = CrystalBuild::Installer::Shards->new(
        fetcher    => '__FETCHER__',
        shards_url => '__SHARDS_URL__',
        cache_dir  => '__CACHE_DIR__',
    );

    my $guard = mock_guard($installer, {
        _resolve  => sub {
            is $_[1], '__CRYSTAL_VERSION__';
            return '__TABALL_URL__';
        },
        _download => sub {
            is $_[1], '__TABALL_URL__';
            is $_[2], '__CRYSTAL_VERSION__';
            return '__EXTRACTED_DIR__';
        },
        _build    => sub {
            is $_[1], '__EXTRACTED_DIR__';
            is $_[2], '__CRYSTAL_BIN__';
            return '__SHARDS_BIN__';
        },
        _copy     => sub {
            is $_[1], '__SHARDS_BIN__';
            is $_[2], '__CRYSTAL_BIN__';
        },
    });

    my ($actual) = capture_stdout {
        $installer->install('__CRYSTAL_VERSION__', '__CRYSTAL_BIN__');
    };

    my $expected = <<EOF;
Resolving Shards download URL ... ok
Downloading Shards tarball ...
__TABALL_URL__
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

done_testing;
