use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Crystal;

subtest basic => sub {
    my $guard = mock_guard('CrystalBuild::Installer::Crystal', {
        _create_resolver => sub {
            my ($self, %opt) = @_;
            is $opt{_resolver_param}, '__PARAM__';
            return '__RESOLVER__';
        },
    });

    my $installer = CrystalBuild::Installer::Crystal->new(
        fetcher         => '__FETCHER__',
        cache_dir       => '__CACHE_DIR__',
        _resolver_param => '__PARAM__',
    );

    isa_ok $installer, 'CrystalBuild::Installer::Crystal';

    is $installer->{fetcher},   '__FETCHER__';
    is $installer->{cache_dir}, '__CACHE_DIR__';
    is $installer->{resolver},  '__RESOLVER__';
};

done_testing;
