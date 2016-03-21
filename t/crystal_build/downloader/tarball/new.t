use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Tarball;

subtest basic => sub {
    my $self = CrystalBuild::Downloader::Tarball->new(fetcher => '__FETCHER__');

    isa_ok $self, 'CrystalBuild::Downloader::Tarball';
    is $self->{fetcher}, '__FETCHER__';
};

done_testing;
