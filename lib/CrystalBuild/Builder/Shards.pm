package CrystalBuild::Builder::Shards;
use CrystalBuild::Sense;

use Cwd qw/abs_path/; # >= perl 5

use CrystalBuild::Utils;
use CrystalBuild::Builder::Shards::LibYAML;

sub new {
    my $class = shift;
    return bless {} => $class;
}

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    CrystalBuild::Builder::Shards::LibYAML->install($target_dir);

    my $command = $self->_create_build_command(
        abs_path("$crystal_dir/libs").':.',
        $target_dir,
        abs_path("$crystal_dir/bin/crystal"),
    );

    system($command) == 0
        or die "shards build faild: $target_dir";

    return "$target_dir/bin/shards";
}


sub _create_build_command {
    my ($self, $env_crystal_path, $target_dir, $crystal_bin) = @_;
    return <<"EOF";
CRYSTAL_PATH=$env_crystal_path \\
LD_LIBRARY_PATH=$target_dir:\$LD_LIBRARY_PATH \\
cd "$target_dir" && "$crystal_bin" build --release src/shards.cr -o bin/shards
EOF
}

1;
