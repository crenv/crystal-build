use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture_stdout/;
use Test::MockObject;

use t::Util;

subtest basic => sub {
    my $crystal_installer = Test::MockObject->new;
    $crystal_installer->mock(install => sub {
        my ($self, $crystal_version, $install_dir) = @_;
        is $crystal_version, '0.7.7';
        is $install_dir,     't/tmp/.crenv/versions/0.7.7';
    });
    $crystal_installer->mock(needs_shards => sub { 1 });

    my $shards_installer = Test::MockObject->new;
    $shards_installer->mock(install => sub {
        my ($self, $crystal_version, $crystal_dir) = @_;
        is $crystal_version, '0.7.7';
        is $crystal_dir,     't/tmp/.crenv/versions/0.7.7';
    });

    my $guard = mock_guard('CrystalBuild', {
        crystal_installer => sub { $crystal_installer },
        shards_installer  => sub { $shards_installer  },
    });

    my $crenv = create_crenv;

    my ($stdout) = capture_stdout {
        $crenv->install('0.7.7');
    };

    my $expected = <<"EOF";
Install successful
EOF

    is $stdout, $expected;

    ok $crystal_installer->called('install');
    ok $crystal_installer->called('needs_shards');
    ok $shards_installer->called('install');
    ok !$shards_installer->called('needs_shards');
};

done_testing;
