use strict;
use warnings;
use utf8;

use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Resolver::Shards;

subtest basic => sub {
    my $releases;
    my $guard = mock_guard('CrystalBuild::Resolver::Shards', {
        _fetch => sub { $releases },
    });
    my $resolver = CrystalBuild::Resolver::Shards->new;

    subtest '#ok' => sub {
        $releases = { '0.11.0' => '__URL__' };
        is $resolver->resolve('0.11.0'), '__URL__';
    };

    subtest '#ok ... default' => sub {
        $releases = { 'default' => '__URL__' };
        is $resolver->resolve('0.10.0'), '__URL__';
    };

    subtest '#ng ... not found' => sub {
        $releases = { '0.11.0' => '__URL__' };
        is $resolver->resolve('0.10.0'), undef;
    };

    subtest '#ng ... null' => sub {
        $releases = undef;
        is $resolver->resolve('0.11.0'), undef;
    };

    subtest '#ng ... string' => sub {
        $releases = 'STRING';
        is $resolver->resolve('0.11.0'), undef;
    };

    subtest '#ng ... array' => sub {
        $releases = [];
        is $resolver->resolve('0.11.0'), undef;
    };
};

done_testing;
