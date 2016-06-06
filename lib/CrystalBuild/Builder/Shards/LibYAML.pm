package CrystalBuild::Builder::Shards::LibYAML;
use CrystalBuild::Sense;

use File::Spec; # > perl 5.002
use File::Which;

use CrystalBuild::Utils;

sub install {
    my ($class, $target_dir) = @_;

    my ($platform) = CrystalBuild::Utils::system_info();
    $class->_install_darwin($target_dir)  if $platform eq 'darwin';
    $class->_install_freebsd($target_dir) if $platform eq 'freebsd';
}

sub _install_darwin {
    my ($class, $target_dir) = @_;

    return print STDERR "You should install Homebrew\n"
        unless which('brew');

    my $prefix = $class->_fetch_brew_libyaml_prefix;
    unless (-d $prefix) {
        print "\n";
        system('brew install libyaml');
        $prefix = $class->_fetch_brew_libyaml_prefix;
    }

    my $src_path  = File::Spec->join($prefix, 'lib/libyaml.a');
    my $dest_path = File::Spec->join($target_dir, 'libyaml.a');
    if (-f $src_path) {
        CrystalBuild::Utils::copy_force($src_path, $dest_path);
    }
}

sub _install_freebsd {
    my ($class, $target_dir) = @_;

    my $src_path  = File::Spec->join('/usr/local/lib/libyaml.so');
    my $dest_path = File::Spec->join($target_dir, 'libyaml.so');
    if (-f $src_path) {
        CrystalBuild::Utils::copy_force($src_path, $dest_path);
    }
}

sub _fetch_brew_libyaml_prefix {
    my $prefix = `brew --prefix libyaml 2>/dev/null`;
    chomp $prefix;
    return $prefix;
}

1;
