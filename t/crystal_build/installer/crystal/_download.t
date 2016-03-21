use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Crystal;
use CrystalBuild::Downloader::Crystal;

subtest basic => sub {
    my $fetcher    = Test::MockObject->new;
    my $downloader = Test::MockObject->new;

    $downloader->mock(download => sub {
        my ($self, $tarball_url, $cache_dir) = @_;

        is $tarball_url, 'http://dummy.url';
        is $cache_dir,   '__CACHE_DIR__/__CRYSTAL_VERSION__';
    });

    my $guard = mock_guard('CrystalBuild::Downloader::Crystal', {
        new => sub {
            my ($class, %opt) = @_;
            is $opt{fetcher}, '__FETCHER__';
            return $downloader;
        },
    });

    my $installer  = CrystalBuild::Installer::Crystal->new(
        fetcher   => '__FETCHER__',
        cache_dir => '__CACHE_DIR__',
    );
    $installer->_download('http://dummy.url', '__CRYSTAL_VERSION__');

    is $guard->call_count('CrystalBuild::Downloader::Crystal', 'new'), 1;
    ok $downloader->called('download');
};

done_testing;
