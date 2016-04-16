use strict;
use warnings;
use utf8;

use t::Util;
use CrystalBuild::Installer::Crystal;

subtest basic => sub {
    my $installer = bless {} => 'CrystalBuild::Installer::Crystal';

    ok !$installer->needs_shards('0.6.0');
    ok !$installer->needs_shards('0.7.6');
    ok $installer->needs_shards('0.7.7');
    ok $installer->needs_shards('0.7.8');
    ok $installer->needs_shards('0.8.0');
    ok $installer->needs_shards('0.10.0');
};

done_testing;
