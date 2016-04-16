use strict;
use warnings;
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;
use File::Path qw/mkpath rmtree/;

use t::Util;
use CrystalBuild::Downloader::Shards;

subtest basic => sub {
    # mocking
    my $fetcher = Test::MockObject->new;
    $fetcher->mock(download => sub {
        my ($self, $tarball_url, $tarball_path) = @_;

        is $self, $fetcher;
        is $tarball_url, 'https://www.example.com/example.tar.gz';
        is $tarball_path, 't/tmp/test.tar.gz';
    });

    my $guard_self = mock_guard('CrystalBuild::Downloader::Shards', {
        _detect_filename => sub {
            my ($self, $url) = @_;
            is $url, 'https://www.example.com/example.tar.gz';
            return 'test.tar.gz';
        },
    });

    my $guard_utils = mock_guard('CrystalBuild::Utils', {
        error_and_exit => sub { },
        extract_tar    => sub {
            my ($tarball_path, $cache_dir) = @_;

            is $tarball_path, 't/tmp/test.tar.gz';
            is $cache_dir, 't/tmp/';

            mkpath 't/tmp/shards-v0.1.0/';
        },
    });

    # before
    ok !-d 't/tmp/shards-v0.1.0';

    # test
    my $self = CrystalBuild::Downloader::Shards->new(fetcher => $fetcher);

    my $target_dir = $self->download('https://www.example.com/example.tar.gz', 't/tmp/');

    # assert
    is $target_dir, 't/tmp/shards-v0.1.0';
    ok -d 't/tmp/shards-v0.1.0';

    ok $fetcher->called('download');
    is $guard_self->call_count('CrystalBuild::Downloader::Shards', '_detect_filename'), 1;
    is $guard_utils->call_count('CrystalBuild::Utils', 'extract_tar'), 1;

    # after
    rmtree 't/tmp/shards-v0.1.0/';
    ok !-d 't/tmp/shards-v0.1.0';
};

done_testing;
