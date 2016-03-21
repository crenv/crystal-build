use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Downloader::Tarball;

subtest succeeded => sub {
    my $self = CrystalBuild::Downloader::Tarball->new(fetcher => '__FETCHER__');

    isa_ok $self, 'CrystalBuild::Downloader::Tarball';
    is $self->{fetcher}, '__FETCHER__';
};

subtest failed => sub {
    throws_ok sub { CrystalBuild::Downloader::Tarball->new }, qr/A fetcher is required/;
};

done_testing;
