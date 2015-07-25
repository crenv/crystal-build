use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Fetcher::Wget;

create_server;

subtest normal => sub {
    my $self = Crenv::Fetcher::Wget->new;
    ok $self->fetch_able(uri_for('test.txt'));
};

subtest failed => sub {
    my $self = Crenv::Fetcher::Wget->new;
    ok not $self->fetch_able(uri_for('invalid_path.txt'));
};

done_testing;
