use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use CrystalBuild::Downloader::Tarball;

subtest basic => sub {
    my $self = bless {} => 'CrystalBuild::Downloader::Tarball';
    throws_ok sub { $self->_detect_extracted_dirs }, qr/\Aabstract method\n\z/;
};

done_testing;
