use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Utils;

subtest basic => sub {
    my $versions        = [ '0.1.0', '0.5.0', '0.4.5', '0.5.10', '0.1.1', '0.5.1' ];
    my $sorted_versions = CrystalBuild::Utils::sort_version($versions);

    cmp_deeply(
        $sorted_versions,
        [ '0.1.0', '0.1.1', '0.4.5', '0.5.0', '0.5.1', '0.5.10' ]
    );
};


done_testing;
