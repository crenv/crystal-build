use strict;
use warnings;
use utf8;

use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest basic => sub {
    my $guard = mock_guard('CrystalBuild::Resolver::Crystal', {
        _create_enable_resolvers => sub {},
    });

    my $resolver = CrystalBuild::Resolver::Crystal->new(
        fetcher           => '__FETCHER__',
        github_repository => '__REPO__',
        remote_cache_url  => '__URL__',
        use_remote_cache  => '__USE_REMOTE_CACHE__',
        use_github        => '__USE_GITHUB__',
    );

    is $resolver->{fetcher},           '__FETCHER__';
    is $resolver->{github_repository}, '__REPO__';
    is $resolver->{remote_cache_url},  '__URL__';
    is $resolver->{use_remote_cache},  '__USE_REMOTE_CACHE__';
    is $resolver->{use_github},        '__USE_GITHUB__';

    isa_ok $resolver, 'CrystalBuild::Resolver::Crystal';
    is $guard->call_count('CrystalBuild::Resolver::Crystal', '_create_enable_resolvers'), 1;
};

done_testing;
