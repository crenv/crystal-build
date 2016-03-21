package CrystalBuild::Downloader::Tarball;

use CrystalBuild::Utils;

use File::Spec;
use File::Path qw/rmtree mkpath/; # => 5.001

sub new {
    my ($class, %opt) = @_;
    my $self = bless {} => $class;

    die 'A fetcher is required' unless $opt{fetcher};
    $self->{fetcher} = $opt{fetcher};

    return $self;
}

sub download {
    my ($self, $tarball_url, $cache_dir) = @_;

    my $filename     = $self->_detect_filename($tarball_url);
    my $tarball_path = File::Spec->join($cache_dir, $filename);

    mkpath $cache_dir unless -e $cache_dir;
    $self->{fetcher}->download($tarball_url, $tarball_path)
        or die "download faild: $tarball_url";

    rmtree $_ for $self->_detect_extracted_dirs($cache_dir);

    CrystalBuild::Utils::extract_tar($tarball_path, $cache_dir);

    my ($target_dir) = $self->_detect_extracted_dirs($cache_dir);
    return $target_dir;
}

sub _detect_filename       { die 'abstract method' }
sub _detect_extracted_dirs { die 'abstract method' }

1;
