package CrystalBuild::Fetcher;
use strict;
use warnings;
use utf8;

use CrystalBuild::Fetcher::Curl;
use CrystalBuild::Fetcher::Wget;

sub create {
    my ($class, $type) = @_;

    return CrystalBuild::Fetcher::Wget->new if $type eq 'wget';
    return CrystalBuild::Fetcher::Curl->new if $type eq 'curl';
    return undef;
}

1;
