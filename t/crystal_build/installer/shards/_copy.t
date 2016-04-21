use strict;
use warnings;
use utf8;

use File::Basename qw/dirname/;
use File::Slurp;
use File::Spec;
use File::Temp qw/tempfile tempdir/;
use File::Touch;
use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use CrystalBuild::Installer::Shards;

subtest basic => sub {
    # ----- before -----

    # create crystal dir
    my $crystal_dir       = tempdir();
    my $target_dir        = File::Spec->catfile($crystal_dir, 'bin');
    my $copied_shards_bin = File::Spec->catfile($target_dir, 'shards');
    mkdir $target_dir;

    # create shards bin
    my ($fh, $shards_bin)  = tempfile();
    my $shars_dir          = dirname($shards_bin);
    my $shards_bin_content = time();

    print $fh $shards_bin_content;
    close $fh;

    ok !-e $copied_shards_bin, 'should not exists';


    # ----- test -----
    my $installer = CrystalBuild::Installer::Shards->new;
    $installer->_copy($shards_bin, $copied_shards_bin);


    # ----- assertion -----
    ok -e $copied_shards_bin, 'should exists';
    ok -r $copied_shards_bin, 'should be able to read';
    ok -x $copied_shards_bin, 'should be able to execute';
    is read_file($copied_shards_bin), $shards_bin_content, 'should have valid content';
};

done_testing;
