package CrystalBuild::Builder::Shards;
use CrystalBuild::Sense;

use Cwd qw/abs_path/; # >= perl 5
use File::Temp qw/tempfile/;
use Text::Caml;

use CrystalBuild::Utils;
use CrystalBuild::Builder::Shards::LibYAML;

sub new {
    my $class = shift;
    return bless {} => $class;
}

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    my ($platform) = CrystalBuild::Utils::system_info();
    my $template   = do { local $/; <DATA> };

    my $params = {
        crystal_dir => $crystal_dir,
        target_dir  => $target_dir,
        platform    => $platform,
    };
    my $script = Text::Caml->new->render($template, $params);

    my ($fh, $filename) = tempfile();
    print $fh $script;
    close $fh;

    chmod 0755, $filename;
    system($filename)
        or die "shards build faild: $target_dir";

    return "$target_dir/bin/shards";
}

1;
__DATA__
#!/bin/bash

set -e

export CRYSTAL_PATH={{crystal_dir}}/libs:{{crystal_dir}}/src:.
export LIBRARY_PATH={{target_dir}}:$LIBRARY_PATH
export LD_LIBRARY_PATH={{target_dir}}:$LD_LIBRARY_PATH

if [ "{{platform}}" = "darwin" ]; then
    if which brew > /dev/null 2>&1; then
        prefix=`brew --prefix libyaml 2>/dev/null`

        if [ "$prefix" = "" ]; then
            brew install libyaml || true
            prefix=`brew --prefix libyaml 2>/dev/null`
        fi

        if [ "$prefix" != "" ]; then
            cp -f "$prefix/lib/libyaml.a" "{{target_dir}}/libyaml.a"
        fi
    fi
fi

cd "{{target_dir}}"
"{{crystal_dir}}/bin/crystal" build --release src/shards.cr -o bin/shards
