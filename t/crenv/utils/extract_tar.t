use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/;
use File::Slurp;
use Archive::Tar;

use t::Util;
use Crenv::Utils;

subtest basic => sub {
    setup_dirs;

    ok not -d 't/tmp/archive';

    Crenv::Utils::extract_tar(
        abs_path('t/data/archive.tar.gz'),
        abs_path('t/tmp/')
    );

    ok -d 't/tmp/archive';
    ok -f 't/tmp/archive/archive.txt';
    ok read_file('t/tmp/archive/archive.txt') =~ /archive\s*/;
};

subtest tar_cmd => sub {
    my $guard = mock_guard('Archive::Tar', {
        new  => sub { die 1 },
        read => sub { },
    });

    setup_dirs;

    ok not -d 't/tmp/archive';

    Crenv::Utils::extract_tar(
        abs_path('t/data/archive.tar.gz'),
        abs_path('t/tmp/')
    );

    ok -d 't/tmp/archive';
    ok -f 't/tmp/archive/archive.txt';
    ok read_file('t/tmp/archive/archive.txt') =~ /archive\s*/;

    is $guard->call_count('Archive::Tar', 'new'), 1;
    is $guard->call_count('Archive::Tar', 'read'), 0;
};

done_testing;
