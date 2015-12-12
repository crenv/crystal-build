use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/;

use t::Util;
use CrystalBuild::Fetcher::Wget;

BEGIN {
    $ENV{PATH} = abs_path('t/bin/').":$ENV{PATH}";
};

subtest basic => sub {
    my $self = CrystalBuild::Fetcher::Wget->new;

    is
        $self->fetch_from_github('http://www.example.com'),
        "-q http://www.example.com --header=Accept: application/vnd.github.v3+json -O -\n";
};

done_testing;
