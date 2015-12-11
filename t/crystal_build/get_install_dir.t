use strict;
use warnings;
use utf8;

use File::Path qw/mkpath/;

use t::Util;

subtest default => sub {
    my $self = create_crenv;

    mkpath 't/tmp/.crenv/versions';
    ok -e 't/tmp/.crenv/versions';

    $self->get_install_dir;

    ok -e 't/tmp/.crenv/versions';
};

subtest mkdir => sub {
    my $self = create_crenv;

    ok not -e 't/tmp/.crenv/versions';

    $self->get_install_dir;

    ok -e 't/tmp/.crenv/versions';
};

done_testing;
