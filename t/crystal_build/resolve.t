use strict;
use warnings;
use utf8;

use Test::MockObject;
use Capture::Tiny qw/capture_stdout/;

use t::Util;
use CrystalBuild;


subtest 'enable cache' => sub {
    subtest 'Remote Cache' => sub {
        my $guard_github = mock_guard('CrystalBuild::Resolver::GitHub', {
            resolve => sub { undef },
        });

        my $guard_cache = mock_guard(
            'CrystalBuild::Resolver::Cache::Remote',
            {
                new => sub {
                    my ($class, %opt) = @_;

                    is $opt{cache_url}, 'http://example.com/releases';
                    isa_ok $opt{fetcher}, 'CrystalBuild::Fetcher::Wget';

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

        my $guard_crenv = mock_guard('CrystalBuild', { cache => sub { 1 } });

        my $crenv = create_crenv;

        my ($stdout) = capture_stdout {
            is
                $crenv->resolve('0.7.5', 'linux', 'x64'),
                'http://www.example.com';
        };

        like $stdout, qr/resolve by Remote Cache: found/i;

        is $guard_cache->call_count('CrystalBuild::Resolver::Cache::Remote', 'resolve'), 1;
        is $guard_github->call_count('CrystalBuild::Resolver::GitHub', 'resolve'), 0;
        is $guard_crenv->call_count('CrystalBuild', 'cache'), 1;
    };

    subtest GitHub => sub {
        my $guard_crenv = mock_guard('CrystalBuild', { cache => sub { 1 } });

        my $guard_cache = mock_guard('CrystalBuild::Resolver::Cache::Remote', {
            resolve => sub { undef },
        });

        my $guard_github = mock_guard(
            'CrystalBuild::Resolver::GitHub',
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

        my ($stdout) = capture_stdout {
            is
                $crenv->resolve('0.7.5', 'linux', 'x64'),
                'http://www.example.com';
        };

        like $stdout, qr/resolve by Remote Cache: not found/i;
        like $stdout, qr/resolve by GitHub: found/i;

        is $guard_cache->call_count('CrystalBuild::Resolver::Cache::Remote', 'resolve'), 1;
        is $guard_github->call_count('CrystalBuild::Resolver::GitHub', 'resolve'), 1;
        is $guard_crenv->call_count('CrystalBuild', 'cache'), 1;
    };
};

subtest 'disabled cache' => sub {
    subtest GitHub => sub {
        my $guard_cache = mock_guard('CrystalBuild::Resolver::Cache::Remote', {
            resolve => sub { undef }
        });

        my $guard_github = mock_guard(
            'CrystalBuild::Resolver::GitHub',
            {
                resolve => sub {
                    my ($self, $version, $platform, $arch) = @_;

                    is $version, '0.7.5';
                    is $platform, 'linux';
                    is $arch, 'x64';

                    return 'http://www.example.com';
                },
            });

        my $guard_crenv = mock_guard('CrystalBuild', { cache => sub { undef } });

        my $crenv = create_crenv;

        my ($stdout) = capture_stdout {
            is
                $crenv->resolve('0.7.5', 'linux', 'x64'),
                'http://www.example.com';
        };

        like $stdout, qr/resolve by GitHub: found/i;

        is $guard_cache->call_count('CrystalBuild::Resolver::Cache::Remote', 'resolve'), 0;
        is $guard_github->call_count('CrystalBuild::Resolver::GitHub', 'resolve'), 1;
        is $guard_crenv->call_count('CrystalBuild', 'cache'), 1;
    };
};

subtest failed => sub {
    my $guard_crenv  = mock_guard('CrystalBuild', {
        cache          => sub { undef },
        error_and_exit => sub {},
    });

    my $guard_github = mock_guard('CrystalBuild::Resolver::GitHub', {
        resolve => sub { undef }
    });

    my $crenv = create_crenv;

    my ($stdout) = capture_stdout {
        ok not $crenv->resolve('0.7.5', 'linux', 'x64');
    };

    like $stdout, qr/resolve by GitHub: not found/i;

    is $guard_github->call_count('CrystalBuild::Resolver::GitHub', 'resolve'), 1;
    is $guard_crenv->call_count('CrystalBuild', 'error_and_exit'), 1;
    is $guard_crenv->call_count('CrystalBuild', 'cache'), 1;
};

done_testing;
