use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::GitHub;

subtest basic => sub {
    my $guard = mock_guard('CrystalBuild::GitHub', {
        fetch    => sub { '{ "status": "ok" }' },
        base_url => sub { 'http://127.0.0.1/' },
    });

    my $github = CrystalBuild::GitHub->new;
    cmp_deeply $github->fetch_as_json('test.json'), { status => "ok" };
};

done_testing;
