use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use Crenv;


subtest 'enable cache' => sub {
    subtest 'Remote Cache' => sub {
        my $guard_github = mock_guard('Crenv::Resolver::GitHub', {
            resolve => sub { undef }
        });

        my $guard_cache = mock_guard(
            'Crenv::Resolver::Cache::Remote',
            {
                new => sub {
                    my ($class, %opt) = @_;

                    is $opt{cache_url}, 'http://example.com/releases';
                    isa_ok $opt{fetcher}, 'Crenv::Fetcher::Wget';

                    return bless {} => $class;
                },
                resolve => sub {
                    my ($self, $version, $platform, $arch) = @_;

                    is $version, '0.7.5';
                    is $platform, 'linux';
                    is $arch, 'x64';

                    return 'http://www.example.com';
                },
            });

        my $crenv = create_crenv;

        is
            $crenv->resolve('0.7.5', 'linux', 'x64', 1),
            'http://www.example.com';

        is $guard_cache->call_count('Crenv::Resolver::Cache::Remote', 'resolve'), 1;
        is $guard_cache->call_count('Crenv::Resolver::GitHub', 'resolve'), 0;
    };

    subtest GitHub => sub {
        my $guard_cache = mock_guard('Crenv::Resolver::Cache::Remote', {
            resolve => sub { undef }
        });

        my $guard_github = mock_guard(
            'Crenv::Resolver::GitHub',
            {
                resolve => sub {
                    my ($self, $version, $platform, $arch) = @_;

                    is $version, '0.7.5';
                    is $platform, 'linux';
                    is $arch, 'x64';

                    return 'http://www.example.com';
                },
            });

        my $crenv = create_crenv;

        is
            $crenv->resolve('0.7.5', 'linux', 'x64', 1),
            'http://www.example.com';

        is $guard_cache->call_count('Crenv::Resolver::Cache::Remote', 'resolve'), 1;
        is $guard_cache->call_count('Crenv::Resolver::GitHub', 'resolve'), 1;
    };
};

subtest 'enable cache' => sub {
    subtest GitHub => sub {
        my $guard_cache = mock_guard('Crenv::Resolver::Cache::Remote', {
            resolve => sub { undef }
        });

        my $guard_github = mock_guard(
            'Crenv::Resolver::GitHub',
            {
                resolve => sub {
                    my ($self, $version, $platform, $arch) = @_;

                    is $version, '0.7.5';
                    is $platform, 'linux';
                    is $arch, 'x64';

                    return 'http://www.example.com';
                },
            });

        my $crenv = create_crenv;

        is
            $crenv->resolve('0.7.5', 'linux', 'x64', 0),
            'http://www.example.com';

        is $guard_cache->call_count('Crenv::Resolver::Cache::Remote', 'resolve'), 0;
        is $guard_cache->call_count('Crenv::Resolver::GitHub', 'resolve'), 1;
    };
};

subtest failed => sub {
    my $guard_crenv  = mock_guard('Crenv', { error_and_exit => sub {} });
    my $guard_github = mock_guard('Crenv::Resolver::GitHub', {
        resolve => sub { undef }
    });


    my $crenv = create_crenv;
    ok not $crenv->resolve('0.7.5', 'linux', 'x64', 0);

    is $guard_github->call_count('Crenv::Resolver::GitHub', 'resolve'), 1;
    is $guard_crenv->call_count('Crenv', 'error_and_exit'), 1;
};

done_testing;
