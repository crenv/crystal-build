use strict;
use warnings;
use utf8;

use t::Util;
require CrystalBuild::Sense;

subtest basic => sub {
    my @features;
    my $guard_strict   = mock_guard('strict',   { import => undef });
    my $guard_warnings = mock_guard('warnings', { import => undef });
    my $guard_utf8     = mock_guard('utf8',     { import => undef });
    my $guard_feature  = mock_guard('feature',  { import => sub { @features = @_[1..$#_ ] } });

    import CrystalBuild::Sense;

    is $guard_strict->call_count('strict', 'import'), 1;
    is $guard_warnings->call_count('warnings', 'import'), 1;
    is $guard_utf8->call_count('utf8', 'import'), 1;
    is $guard_feature->call_count('feature', 'import'), 1;

    cmp_deeply [ @features ], [qw/say state/];
};

done_testing;
