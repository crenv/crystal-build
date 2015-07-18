use strict;
use warnings;
use utf8;

use t::Util;

use Crenv::Utils;

subtest basic => sub {
    my $args = Crenv::Utils::parse_args('0.7.4', 'prefix');
    is $args->{version}, '0.7.4';
    is $args->{prefix}, 'prefix';
    ok not $args->{definitions};
};

subtest definitions => sub {
    push @ARGV, '--definitions';

    my $args = Crenv::Utils::parse_args;
    ok $args->{definitions};
};

done_testing;
