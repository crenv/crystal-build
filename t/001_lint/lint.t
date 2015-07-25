use strict;
use warnings;
use utf8;

use t::Util;

eval {
    require Test::Perl::Critic;
    Test::Perl::Critic->import( -profile => 't/perlcriticrc' );
};

all_critic_ok('lib', 't', 'bin/crystal-build');
