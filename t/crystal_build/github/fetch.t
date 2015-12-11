use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::GitHub;
use CrystalBuild::Fetcher;

subtest basic => sub {
    my $guard = mock_guard('CrystalBuild::Fetcher::Wget', {
        fetch_from_github => sub {
            my ($self, $url) = @_;
            die if $url ne 'http://dummy.url/';
        }
    });

    my $fetcher = CrystalBuild::Fetcher->create('wget');
    my $github  = CrystalBuild::GitHub->new(fetcher => $fetcher);

    $github->fetch('http://dummy.url/');
    is $guard->call_count('CrystalBuild::Fetcher::Wget', 'fetch_from_github'), 1;
};

done_testing;
