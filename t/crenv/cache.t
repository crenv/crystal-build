use strict;
use warnings;
use utf8;

use t::Util;

subtest basic => sub {
    my $crenv = create_crenv;
    $crenv->{cache} = 'is_cache_enabled';
    is $crenv->cache, 'is_cache_enabled';
};

done_testing;
