use strict;
use warnings;
use utf8;

use Test::Mock::Guard;

use t::Util;
use Crenv;

subtest basic => sub {
    my $guard = mock_guard('Crenv', {
       versions => sub {
           return [ '0.5.0', '0.6.0', '0.5.1' ];
       },
       normalize_version => sub { $_[1] },
    });

    my $crenv = create_crenv;

    cmp_deeply
        $crenv->avaiable_versions,
        [ '0.5.0', '0.6.0', '0.5.1' ];
};

done_testing;
