use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::GitHub;

subtest basic => sub {
    my $github = CrystalBuild::GitHub->new(github_repo => 'author/repo');
    is $github->base_url, 'https://api.github.com/repos/author/repo/';
};

done_testing;
