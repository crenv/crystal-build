package CrystalBuild::Fetcher;
use strict;
use warnings;
use utf8;

use CrystalBuild::Fetcher::Curl;
use CrystalBuild::Fetcher::Wget;

sub get {
    my ($class, $type) = @_;

    $type eq 'wget' ? CrystalBuild::Fetcher::Wget->new :
    $type eq 'curl' ? CrystalBuild::Fetcher::Curl->new :
    die 'Fetcher type invalid';
}

1;
