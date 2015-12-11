use strict;
use warnings;
use utf8;

use Capture::Tiny qw/capture_stdout/;

use t::Util;


create_server;

subtest basic => sub {
    my $url   = uri_for('crystal-0.7.4-1.tar.gz');
    my $guard = mock_guard('CrystalBuild', {
        system_info => sub {
            return ('linux', 'x64');
        },
        resolve => sub {
            my ($self, $version, $platform, $arch) = @_;
            is $version, '0.7.4';
            is $platform, 'linux';
            is $arch, 'x64';

            return $url;
        },
    });

    my $crenv = create_crenv;

    my ($stdout) = capture_stdout {
        $crenv->install('0.7.4');
    };

    my $expected = <<"EOF";
resolve: crystal-0.7.4-linux-x64
fetch: $url
Install successful
EOF

    is $stdout, $expected;

    ok -d 't/tmp/.crenv/versions/0.7.4/bin';
    ok -d 't/tmp/.crenv/versions/0.7.4/src';
    is `t/tmp/.crenv/versions/0.7.4/bin/crystal`, "crystal\n";

    is $guard->call_count('CrystalBuild', 'system_info'), 1;
    is $guard->call_count('CrystalBuild', 'resolve'), 1;
};

done_testing;
