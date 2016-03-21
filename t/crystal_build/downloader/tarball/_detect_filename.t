use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Tarball;

subtest basic => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Tarball';
    throws_ok sub { $self->_detect_filename }, qr/abstract method/;
};

done_testing;
