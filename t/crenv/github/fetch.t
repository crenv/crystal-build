use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::GitHub;
use Crenv::Fetcher;

subtest basic => sub {
    my $guard = mock_guard('Crenv::Fetcher::Wget', {
        fetch_from_github => sub {
            my ($self, $url) = @_;
            die if $url ne 'http://dummy.url/';
        }
    });

    my $fetcher = Crenv::Fetcher->get('wget');
    my $github  = Crenv::GitHub->new(fetcher => $fetcher);

    $github->fetch('http://dummy.url/');
    is $guard->call_count('Crenv::Fetcher::Wget', 'fetch_from_github'), 1;
};

done_testing;
