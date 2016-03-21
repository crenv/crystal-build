use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Crystal;

subtest basic => sub {
    my $self = CrystalBuild::Downloader::Crystal->new(fetcher => '__FETCHER__');

    isa_ok $self, 'CrystalBuild::Downloader::Crystal';
    is $self->{fetcher}, '__FETCHER__';
};

done_testing;
