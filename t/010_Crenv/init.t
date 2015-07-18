use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/;

use t::Util;

subtest basic => sub {
    my $self = create_crenv;

    is abs_path($self->{versions_dir}), abs_path('t/tmp/.crenv/versions');
    is abs_path($self->{cache_dir}), abs_path('t/tmp/.crenv/cache');
};

done_testing;
