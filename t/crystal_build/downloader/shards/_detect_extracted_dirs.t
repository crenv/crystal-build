use strict;
use warnings FATAL => 'all';
use utf8;

use File::Path qw/mkpath/;
use File::Touch;

use t::Util;
use CrystalBuild::Downloader::Shards;

setup_dirs;

subtest basic => sub {
    # ----- setup -----------------------------------------
    mkpath 't/tmp/.crenv/cache';

    touch 't/tmp/.crenv/cache/shards-file';
    mkpath 't/tmp/.crenv/cache/shards-dir';

    ok -f 't/tmp/.crenv/cache/shards-file';
    ok -d 't/tmp/.crenv/cache/shards-dir';


    # ----- assert ----------------------------------------
    my $self = bless {} => 'CrystalBuild::Downloader::Shards';
    cmp_deeply
        [ $self->_detect_extracted_dirs('t/tmp/.crenv/cache') ],
        ['t/tmp/.crenv/cache/shards-dir'];
};

done_testing;
