use strict;
use warnings FATAL => 'all';
use utf8;

use Capture::Tiny qw/capture/;
use File::Slurp;
use File::Temp qw/tempdir/;

use t::Util;
use CrystalBuild::Homebrew;

subtest basic => sub {
    # setup
    my $bin_dir  = tempdir();
    my $bin_path = File::Spec->catfile($bin_dir, 'brew');

    write_file($bin_path, <DATA>);
    chmod 0755, $bin_path;

    # -------------------------------------------------------------------------

    subtest 'ok: exists' => sub {
        local $ENV{PATH} = $bin_dir;
        my $brew = CrystalBuild::Homebrew->new;
        ok $brew->exists('bdw-gc');
    };

    subtest 'ok: not exists' => sub {
        local $ENV{PATH} = $bin_dir;
        my $brew = CrystalBuild::Homebrew->new;
        ok !$brew->exists('llvm');
    };

    subtest 'ng: brew not found' => sub {
        local $ENV{PATH} = '';
        capture {
            my $brew = CrystalBuild::Homebrew->new;
            ok !$brew->exists('llvm');
        };
    };
};

done_testing;
__DATA__
#!/bin/bash

echo bdw-gc
echo libevent
