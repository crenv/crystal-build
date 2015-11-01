package Crenv::Builder::Shards;
use strict;
use warnings;
use utf8;

use Cwd qw/abs_path/; # >= perl 5

use Crenv::Utils;

sub new {
    my $class = shift;
    bless {} => $class;
}

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    $self->install_libyaml($target_dir);

    my $crystal_bin      = abs_path("$crystal_dir/bin/crystal");
    my $env_crystal_path = abs_path("$crystal_dir/libs").':.';

    my $command = <<"EOF";
CRYSTAL_PATH=$env_crystal_path \
LD_LIBRARY_PATH=$target_dir:\$LD_LIBRARY_PATH \
cd "$target_dir" && "$crystal_bin" build --release src/shards.cr -o bin/shards
EOF

    system($command) == 0
        or Crenv::Utils::error_and_exit("shards build faild: $target_dir");

    return "$target_dir/bin/shards";
}

sub install_libyaml {
    my ($self, $target_dir) = @_;

    my ($platform) = Crenv::Utils::system_info();
    if ($platform eq 'darwin') {
        $self->install_libyaml_with_brew($target_dir);
    }
}

sub install_libyaml_with_brew {
    my ($self, $target_dir) = @_;

    unless (system('which brew > /dev/null 2>&1') == 0) {
        print STDERR "You should install Homebrew\n";
        return;
    }

    my $prefix = $self->fetch_libyaml_prefix_with_brew;
    unless (-d $prefix) {
        system('brew install libyaml');
        $prefix = $self->fetch_libyaml_prefix_with_brew;
    }

    my $libyaml_path = File::Spec->join($prefix, "lib/libyaml.a");
    if (-f $libyaml_path) {
        system("cp -f \"$libyaml_path\" \"$target_dir/libyaml.a\"");
    }
}

sub fetch_libyaml_prefix_with_brew {
    my $self = shift;

    my $prefix = `brew --prefix libyaml 2>/dev/null`;
    chomp $prefix;

    return $prefix;
}

1;
