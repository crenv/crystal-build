use strict;
use warnings FATAL => 'all';
use utf8;

use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Crystal;

use constant CRYSTAL_VERSION => '0.15.0';
use constant PLATFORM        => 'darwin';
use constant ARCHITECTURE    => 'x64';

subtest basic => sub {
    my $guard_utils = mock_guard('CrystalBuild::Utils', {
        system_info => sub { (PLATFORM, ARCHITECTURE) },
    });

    my $guard_resolver = mock_guard('CrystalBuild::Resolver::Crystal', {
        resolve => sub {
            my ($self, $version, $platform, $arch) = @_;
            is $version,  CRYSTAL_VERSION;
            is $platform, PLATFORM;
            is $arch,     ARCHITECTURE;
        },
    });

    my $resolver = bless {} => 'CrystalBuild::Resolver::Crystal';
    $resolver->resolve_by_version(CRYSTAL_VERSION);

    is $guard_utils->call_count('CrystalBuild::Utils', 'system_info'), 1;
    is $guard_resolver->call_count('CrystalBuild::Resolver::Crystal', 'resolve'), 1;
};

done_testing;
