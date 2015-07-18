use strict;
use warnings;
use utf8;

use t::Util;
use Crenv::GitHub;

subtest basic => sub {
    no warnings 'redefine';

    local *Crenv::GitHub::fetch = sub {
        is $_[1], 'https://api.github.com/repos/author/repo/releases/tags/0.7.4';
        '{ "status": "ok" }';
    };

    my $github = Crenv::GitHub->new(github_repo => 'author/repo');
    cmp_deeply $github->fetch_release('0.7.4'), { status => 'ok' };
};

done_testing;
