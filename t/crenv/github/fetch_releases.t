use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::GitHub;

subtest basic => sub {
    no warnings 'redefine';

    local *CrystalBuild::GitHub::fetch = sub {
        is $_[1], 'https://api.github.com/repos/author/repo/releases?per_page=100';
        '{ "status": "ok" }';
    };

    my $github = CrystalBuild::GitHub->new(github_repo => 'author/repo');
    cmp_deeply $github->fetch_releases, { status => 'ok' };
};

done_testing;
