use strict;
use warnings;
use utf8;

use Test::MockObject;
use Capture::Tiny qw/capture_stdout/;

use t::Util;

subtest show_definitions => sub {
    my $installer = Test::MockObject->new;
    $installer->mock(versions => sub { [ '0.7.0', '0.5.0', '0.6.1' ] });

    my $guard = mock_guard('CrystalBuild', {
        crystal_installer => sub { $installer },
    });

    my $crenv = create_crenv;

    # show_definitions doesn't sort
    my ($stdout) = capture_stdout { $crenv->show_definitions };
    is $stdout, "0.7.0\n0.5.0\n0.6.1\n";
};

done_testing;
