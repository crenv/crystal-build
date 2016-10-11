use strict;
use warnings FATAL => 'all';
use utf8;

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

    subtest 'ok: detected' => sub {
        local $ENV{PATH} = $bin_dir;

        my $brew = CrystalBuild::Homebrew->new;
        ok $brew->alive();
    };

    subtest 'ok: not detected' => sub {
        local $ENV{PATH} = '';

        my $brew = CrystalBuild::Homebrew->new;
        ok !$brew->alive();
    };
};

done_testing;
__DATA__
#!/bin/bash

exit 0
