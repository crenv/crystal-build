use strict;
use warnings FATAL => 'all';
use utf8;

use File::Path qw/mkpath/;
use File::Touch;

use t::Util;
use CrystalBuild::Downloader::Crystal;

setup_dirs;

subtest basic => sub {
    # ----- setup -----------------------------------------
    mkpath 't/tmp/.crenv/cache';

    touch 't/tmp/.crenv/cache/crystal-file';
    mkpath 't/tmp/.crenv/cache/crystal-dir';

    ok -f 't/tmp/.crenv/cache/crystal-file';
    ok -d 't/tmp/.crenv/cache/crystal-dir';


    # ----- assert ----------------------------------------
    my $self = bless {} => 'CrystalBuild::Downloader::Crystal';
    cmp_deeply
        [ $self->_detect_extracted_dirs('t/tmp/.crenv/cache') ],
        ['t/tmp/.crenv/cache/crystal-dir'];
};

done_testing;
