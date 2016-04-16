use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture_stdout/;
use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Crystal;

subtest basic => sub {
    my $guard = mock_guard('CrystalBuild::Installer::Crystal', {
        _resolve => sub {
            my ($self, $crystal_version) = @_;
            is $crystal_version, '__CRYSTAL_VERSION__';
            return '__URL__';
        },
        _download => sub {
            my ($self, $tarball_url, $crystal_version) = @_;
            is $tarball_url,     '__URL__';
            is $crystal_version, '__CRYSTAL_VERSION__';
            return '__DIR__';
        },
        _move     => sub {
            my ($self, $extracted_dir, $install_dir) = @_;
            is $extracted_dir, '__DIR__';
            is $install_dir,   '__INSTALL_DIR__';
        },
    });

    my $installer = bless {} => 'CrystalBuild::Installer::Crystal';
    my ($actual) = capture_stdout {
        $installer->install('__CRYSTAL_VERSION__', '__INSTALL_DIR__');
    };

    is $guard->call_count('CrystalBuild::Installer::Crystal', '_resolve'),  1;
    is $guard->call_count('CrystalBuild::Installer::Crystal', '_download'), 1;
    is $guard->call_count('CrystalBuild::Installer::Crystal', '_move'),     1;
};

done_testing;
