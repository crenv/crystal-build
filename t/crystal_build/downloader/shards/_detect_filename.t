use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use CrystalBuild::Downloader::Shards;

use constant VALID_URL =>
    'https://github.com/ysbaddaden/shards/archive/v0.5.3.tar.gz';

subtest succeeded => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Shards';
    is $self->_detect_filename(VALID_URL), 'shards-v0.5.3.tar.gz';
};

subtest failed => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Shards';

    subtest '# undef' => sub {
        dies_ok { $self->_detect_filename };
    };

    subtest '# invalid URL' => sub {
        dies_ok { $self->_detect_filename('http://www.example.com/') };
    };
};

done_testing;
