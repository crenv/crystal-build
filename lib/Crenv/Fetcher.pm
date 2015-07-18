package Crenv::Fetcher;
use strict;
use warnings;
use utf8;

use Crenv::Fetcher::Curl;
use Crenv::Fetcher::Wget;

sub get {
    my ($class, $type) = @_;

    $type eq 'wget' ? Crenv::Fetcher::Wget->new:
    $type eq 'curl' ? Crenv::Fetcher::Curl->new:
    die 'Fetcher type invalid';
}

1;
