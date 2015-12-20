use strict;
use warnings;
use utf8;

use HTTP::Command::Wrapper;

use t::Util;
use CrystalBuild::GitHub;

subtest basic => sub {
    my $guard = mock_guard('HTTP::Command::Wrapper::Wget', {
        fetch => sub {
            my ($self, $url) = @_;
            die if $url ne 'http://dummy.url/';
        }
    });

    my $fetcher = HTTP::Command::Wrapper->create('wget');
    my $github  = CrystalBuild::GitHub->new(fetcher => $fetcher);

    $github->fetch('http://dummy.url/');
    is $guard->call_count('HTTP::Command::Wrapper::Wget', 'fetch'), 1;
};

done_testing;
