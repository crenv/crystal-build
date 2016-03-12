use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest basic => sub {
    my $resolver = bless {
        fetcher           => '__FETCHER__',
        github_repository => '__REPO__',
    } => 'CrystalBuild::Resolver::Crystal';

    my $github_resolver = $resolver->_create_github_resolver;

    is $github_resolver->{github}->{fetcher},     '__FETCHER__';
    is $github_resolver->{github}->{github_repo}, '__REPO__';
};

done_testing;
