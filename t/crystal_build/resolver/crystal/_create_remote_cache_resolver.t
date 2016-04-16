use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest basic => sub {
    my $resolver = bless {
        fetcher          => '__FETCHER__',
        remote_cache_url => '__URL__',
    } => 'CrystalBuild::Resolver::Crystal';

    my $remote_cache_resolver = $resolver->_create_remote_cache_resolver;

    is $remote_cache_resolver->{fetcher},   '__FETCHER__';
    is $remote_cache_resolver->{cache_url}, '__URL__';
};

done_testing;
