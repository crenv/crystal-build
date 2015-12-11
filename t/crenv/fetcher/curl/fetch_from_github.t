use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/;

use t::Util;
use CrystalBuild::Fetcher::Curl;

BEGIN {
    $ENV{PATH} = abs_path('t/bin/').":$ENV{PATH}";
};

subtest basic => sub {
    my $self = CrystalBuild::Fetcher::Curl->new;

    is
        $self->fetch_from_github('http://www.example.com'),
        "-H Accept: application/vnd.github.v3+json -Ls http://www.example.com\n";
};

done_testing;
