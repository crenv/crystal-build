use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Crystal;

use constant VALID_URL =>
    'https://github.com/crystal-lang/crystal/releases/download/0.12.0/crystal-0.12.0-1-darwin-x86_64.tar.gz';

subtest succeeded => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Crystal';
    is $self->_detect_filename(VALID_URL), 'crystal-0.12.0-1-darwin-x86_64.tar.gz';
};

subtest failed => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Crystal';

    subtest '# undef' => sub {
        dies_ok { $self->_detect_filename };
    };

    subtest '# invalid URL' => sub {
        dies_ok { $self->_detect_filename('http://www.example.com/') };
    };
};

done_testing;
