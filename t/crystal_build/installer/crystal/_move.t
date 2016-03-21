use strict;
use warnings;
use utf8;

use File::Touch;
use File::Path qw/rmtree mkpath/;
use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Crystal;
use CrystalBuild::Downloader::Crystal;

use constant CACHE_DIR   => 't/tmp/.crenv/cache/0.13.0/crystal-0.13.0-1';
use constant INSTALL_DIR => 't/tmp/.crenv/versions/0.13.0';

sub run_tests {
    # ----- setup -----------------------------------------
    mkpath CACHE_DIR;
    touch CACHE_DIR.'/file';

    ok !-f INSTALL_DIR.'/file';

    my $installer  = bless {} => 'CrystalBuild::Installer::Crystal';
    $installer->_move(CACHE_DIR, INSTALL_DIR);


    # ----- assert ----------------------------------------
    ok -d INSTALL_DIR;
    ok -f INSTALL_DIR.'/file';
}

subtest succeeded => sub {
    subtest '# clean' => sub {
        setup_dirs;
        run_tests;
    };

    subtest '# exists' => sub {
        setup_dirs;
        mkpath INSTALL_DIR;
        run_tests;
    };
};

done_testing;
