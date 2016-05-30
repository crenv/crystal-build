use strict;
use warnings;
use utf8;

use Test::MockObject;

use t::Util;
use CrystalBuild::Resolver::Crystal::GitHub;

use constant LINUX_X86_URL   => 'http://www.example.com/linux/x86';
use constant LINUX_X64_URL   => 'http://www.example.com/linux/x64';
use constant DARWIN_X64_URL  => 'http://www.example.com/darwin/x64';
use constant FREEBSD_X64_URL => 'http://www.example.com/freebsd/x64';

subtest basic => sub {
    my $github = Test::MockObject->new;
    $github->mock(fetch_release => sub {
        my ($self, $version) = @_;
        is $version, '0.7.5';
        return { assets => [ $version ] };
    });

    my $guard = mock_guard(
        'CrystalBuild::Resolver::Crystal::GitHub', {
            github => sub { $github },
            _find_binary_download_urls => sub {
                my ($class, $assets) = @_;

                cmp_deeply $assets, [ '0.7.5' ];

                return {
                    'linux-x86'   => LINUX_X86_URL,
                    'linux-x64'   => LINUX_X64_URL,
                    'darwin-x64'  => DARWIN_X64_URL,
                    'freebsd-x64' => FREEBSD_X64_URL,
                };
            },
        });

    my $resolver = CrystalBuild::Resolver::Crystal::GitHub->new;

    is $resolver->resolve('0.7.5', 'linux', 'x86'),   LINUX_X86_URL;
    is $resolver->resolve('0.7.5', 'linux', 'x64'),   LINUX_X64_URL;
    is $resolver->resolve('0.7.5', 'darwin', 'x64'),  DARWIN_X64_URL;
    is $resolver->resolve('0.7.5', 'freebsd', 'x64'), FREEBSD_X64_URL;

    ok $github->called('fetch_release');
    is $guard->call_count('CrystalBuild::Resolver::Crystal::GitHub', 'github'), 4;
    is $guard->call_count('CrystalBuild::Resolver::Crystal::GitHub', '_find_binary_download_urls'), 4;
};

done_testing;
