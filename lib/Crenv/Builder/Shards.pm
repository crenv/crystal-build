package Crenv::Builder::Shards;
use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/; # >= perl 5

use Crenv::Utils;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    $self->_install_libyaml;

    my $crystal_bin      = abs_path("$crystal_dir/bin/crystal");
    my $env_crystal_path = abs_path("$crystal_dir/libs").':.';

    my $command = <<"EOF";
CRYSTAL_PATH=$env_crystal_path \
cd "$target_dir" && "$crystal_bin" build --release src/shards.cr -o bin/shards
EOF

    system($command) == 0
        or Crenv::Utils::error_and_exit("shards build faild: $target_dir");

    return "$target_dir/bin/shards";
}

sub _install_libyaml {
    my ($platform, $arch) = Crenv::Utils::system_info();

    if ($platform eq 'darwin') {
        return unless system('which brew > /dev/null 2>&1') == 0;

        if (system('brew list libyaml > /dev/null 2>&1') != 0) {
            system('brew install libyaml');
        }
    }
}


1;
