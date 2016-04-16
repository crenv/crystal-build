use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Resolver::Crystal;

subtest '# empty' => sub {
    my $resolver = bless {} => 'CrystalBuild::Resolver::Crystal';
    is @{ $resolver->_create_enable_resolvers }, 0;
};

subtest '# remote' => sub {
    subtest '# only remote' => sub {
        my $resolver = bless { use_remote_cache => 1 } => 'CrystalBuild::Resolver::Crystal';
        is @{ $resolver->_create_enable_resolvers }, 1;
        isa_ok $resolver->_create_enable_resolvers->[0], 'CrystalBuild::Resolver::Crystal::RemoteCache';
    };

    subtest '# with github' => sub {
        my $resolver = bless { use_remote_cache => 1, use_github => 1, } => 'CrystalBuild::Resolver::Crystal';

        is @{ $resolver->_create_enable_resolvers }, 2;
        isa_ok $resolver->_create_enable_resolvers->[0], 'CrystalBuild::Resolver::Crystal::RemoteCache';
        isa_ok $resolver->_create_enable_resolvers->[1], 'CrystalBuild::Resolver::Crystal::GitHub';
    };
};

subtest '# github' => sub {
    my $resolver = bless { use_github => 1 } => 'CrystalBuild::Resolver::Crystal';
    is @{ $resolver->_create_enable_resolvers }, 1;
    isa_ok $resolver->_create_enable_resolvers->[0], 'CrystalBuild::Resolver::Crystal::GitHub';
};

done_testing;
