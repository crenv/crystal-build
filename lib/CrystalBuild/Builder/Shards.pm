package CrystalBuild::Builder::Shards;
use CrystalBuild::Sense;

use Cwd qw/abs_path/; # >= perl 5
use File::Temp qw/tempfile/;
use Text::Caml;

use CrystalBuild::Utils;

sub new {
    my ($class, %opt) = @_;
    bless { %opt } => $class;
}

sub without_release  { shift->{without_release} }

sub build {
    my ($self, $target_dir, $crystal_dir) = @_;

    my $shards_bin = "$target_dir/bin/shards";

    {
        my $script = $self->_create_build_script($target_dir, $crystal_dir);
        return $shards_bin if $self->_run_script($script);
    }

    print "\n";
    print 'Retry building Shards ... ';

    {
        my $script = $self->_create_build_script($target_dir, $crystal_dir, 1);
        return $shards_bin if $self->_run_script($script);
    }

    die "shards build faild: $target_dir";
}

sub _create_build_script {
    my ($self, $target_dir, $crystal_dir, $no_pie_fg) = @_;

    my ($platform) = CrystalBuild::Utils::system_info();
    my $template   = $self->_get_data_section;
    my $params     = {
        crystal_dir           => abs_path($crystal_dir),
        target_dir            => $target_dir,
        platform              => $platform,
        link_flags            => $no_pie_fg ? '-no-pie' : '',
        without_release_flags => $self->without_release ? '' : '--release --no-debug',
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

sub _get_data_section {
    my $pos  = tell DATA;
    my $data = do { local $/; <DATA> };

    seek DATA, $pos, 0;

    return $data;
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

if [ -z "{{link_flags}}" ]; then
    "{{crystal_dir}}/bin/crystal" build src/shards.cr -o bin/shards {{without_release_flags}}
else
    "{{crystal_dir}}/bin/crystal" build src/shards.cr -o bin/shards --link-flags "{{link_flags}}" {{without_release_flags}}
fi
