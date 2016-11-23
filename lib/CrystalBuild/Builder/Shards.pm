package CrystalBuild::Builder::Shards;
use CrystalBuild::Sense;

use Cwd qw/abs_path/; # >= perl 5
use File::Temp qw/tempfile/;
use Text::Caml;

use CrystalBuild::Utils;

sub new {
    my $class = shift;
    return bless {} => $class;
}

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    my $script = $self->_create_build_script($target_dir, $crystal_dir);
    $self->_run_script($script)
        or die "shards build faild: $target_dir";

    return "$target_dir/bin/shards";
}

sub _create_build_script {
    my ($self, $target_dir, $crystal_dir) = @_;

    my ($platform) = CrystalBuild::Utils::system_info();
    my $template   = do { local $/; <DATA> };
    my $params     = {
        crystal_dir => abs_path($crystal_dir),
        target_dir  => $target_dir,
        platform    => $platform,
    };

    return Text::Caml->new->render($template, $params);
}

sub _run_script {
    my ($self, $script) = @_;

    my ($fh, $filename) = tempfile();
    print $fh $script;
    close $fh;

    chmod 0755, $filename;
    return system($filename) == 0;
}

1;
__DATA__
#!/usr/bin/env bash

set -e

export CRYSTAL_PATH={{crystal_dir}}/libs:{{crystal_dir}}/src:{{crystal_dir}}/lib:.
export LIBRARY_PATH={{target_dir}}:/usr/local/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH={{target_dir}}:/usr/local/lib:$LD_LIBRARY_PATH

if [ "{{platform}}" = "darwin" ]; then
    if which brew > /dev/null 2>&1; then
        prefix=`brew --prefix libyaml 2>/dev/null`

        if [ ! -f "$prefix/lib/libyaml.a" ]; then
            echo ""
            brew install libyaml || true
            prefix=`brew --prefix libyaml 2>/dev/null`
        fi

        if [ -f "$prefix/lib/libyaml.a" ]; then
            cp -f "$prefix/lib/libyaml.a" "{{target_dir}}/libyaml.a"
        fi
    fi
fi

cd "{{target_dir}}"
"{{crystal_dir}}/bin/crystal" build --release src/shards.cr -o bin/shards
