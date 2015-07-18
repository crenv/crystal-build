use strict;
use warnings;
use utf8;

use File::Path qw/mkpath/;

use t::Util;

subtest all => sub {
    my $self = create_crenv;

    mkpath 't/tmp/.crenv/cache/0.7.4';
    mkpath 't/tmp/.crenv/cache/0.6.0';

    ok -d 't/tmp/.crenv/cache/0.7.4';
    ok -d 't/tmp/.crenv/cache/0.6.0';

    $self->clean('all');

    ok not -d 't/tmp/.crenv/cache/0.7.4';
    ok not -d 't/tmp/.crenv/cache/0.6.0';
};

subtest version => sub {
    my $self = create_crenv;

    mkpath 't/tmp/.crenv/cache/0.7.4';
    mkpath 't/tmp/.crenv/cache/0.6.0';

    ok -d 't/tmp/.crenv/cache/0.7.4';
    ok -d 't/tmp/.crenv/cache/0.6.0';

    $self->clean('0.7.4');

    ok not -d 't/tmp/.crenv/cache/0.7.4';
    ok -d 't/tmp/.crenv/cache/0.6.0';
};

subtest nothing => sub {
    my $self = create_crenv;

    ok not -d 't/tmp/.crenv/cache/0.7.4';

    $self->clean('0.7.4');

    ok not -d 't/tmp/.crenv/cache/0.7.4';
};

done_testing;
