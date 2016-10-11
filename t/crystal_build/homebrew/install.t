use strict;
use warnings FATAL => 'all';
use utf8;

use Capture::Tiny qw/capture capture_stdout/;
use Data::Section::Simple qw/get_data_section/;
use File::Slurp;
use File::Temp qw/tempdir/;

use t::Util;
use CrystalBuild::Homebrew;

subtest basic => sub {
    # setup
    my $bin_dir  = tempdir();
    my $bin_path = File::Spec->catfile($bin_dir, 'brew');

    # -------------------------------------------------------------------------

    subtest 'ok: install succeeded' => sub {
        local $ENV{PATH} = $bin_dir;
        write_file($bin_path, get_data_section('exit_0.sh'));
        chmod 0755, $bin_path;

        my $stdout = capture_stdout {
            my $brew = CrystalBuild::Homebrew->new;
            ok $brew->install('libevent');
        };

        is $stdout, <<EOF;
Installing libevent by Homebrew
install libevent
EOF
    };

    subtest 'ok: install failed' => sub {
        local $ENV{PATH} = $bin_dir;
        write_file($bin_path, get_data_section('exit_1.sh'));
        chmod 0755, $bin_path;

        my $stdout = capture_stdout {
            my $brew = CrystalBuild::Homebrew->new;
            ok !$brew->install('libevent');
        };

        is $stdout, <<EOF;
Installing libevent by Homebrew
install libevent
EOF
    };

    subtest 'ng: command not found' => sub {
        local $ENV{PATH} = '';
        capture {
            my $brew = CrystalBuild::Homebrew->new;
            ok! $brew->install('libevent');
        };
    };
};

done_testing;
__DATA__
@@ exit_0.sh
#!/bin/bash
echo $*
exit 0

@@ exit_1.sh
#!/bin/bash
echo $*
exit 1
