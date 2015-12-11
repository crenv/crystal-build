use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::GitHub;

subtest basic => sub {
    my $github = Test::MockObject->new;
    $github->mock(fetch_release => sub {
        my ($self, $version) = @_;
        is $version, '0.7.5';
        return { assets => [ $version ] };
    });

    my $guard = mock_guard(
        'CrystalBuild::Resolver::GitHub', {
            github => sub { $github },
            _find_binary_download_urls => sub {
                my ($class, $assets) = @_;

                cmp_deeply $assets, [ '0.7.5' ];

                return {
                    'darwin-x64' => 'http://www.example.com/darwin/x64',
                };
            },
        });

    my $resolver = CrystalBuild::Resolver::GitHub->new;

    is
        $resolver->resolve('0.7.5', 'darwin', 'x64'),
        'http://www.example.com/darwin/x64';

    ok $github->called('fetch_release');
    is $guard->call_count('CrystalBuild::Resolver::GitHub', 'github'), 1;
    is $guard->call_count('CrystalBuild::Resolver::GitHub', '_find_binary_download_urls'), 1;
};

done_testing;
