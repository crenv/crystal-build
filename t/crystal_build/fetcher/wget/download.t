use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Fetcher::Wget;

create_server;

subtest normal => sub {
    setup_dirs;

    my $self = CrystalBuild::Fetcher::Wget->new;
    ok $self->download(uri_for('test.txt'), 't/tmp/test.txt');
    is length `diff t/data/test.txt t/tmp/test.txt`, 0;
};

done_testing;
