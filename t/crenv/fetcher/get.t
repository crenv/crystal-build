use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Fetcher;

subtest wget => sub {
    my $self = CrystalBuild::Fetcher->get('wget');
    isa_ok $self, 'CrystalBuild::Fetcher::Wget';
};

subtest curl => sub {
    my $self = CrystalBuild::Fetcher->get('curl');
    isa_ok $self, 'CrystalBuild::Fetcher::Curl';
};

done_testing;
