use strict;
use warnings;
use utf8;

use t::Util;
use Crenv::Downloader::Shards;

subtest basic => sub {
    my $self = Crenv::Downloader::Shards->new;

    is
        $self->_detect_filename('https://github.com/ysbaddaden/shards/archive/v0.5.3.tar.gz'),
        'shards-v0.5.3.tar.gz';

    is
        $self->_detect_filename('https://github.com/ysbaddaden/shards/archive/'),
        'shards.tar.gz';
};

done_testing;
