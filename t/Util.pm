package t::Util;

use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Exporter 'import';
use Data::Dumper;

use Test::More;
use Test::Deep;
use Test::Deep::Matcher;
use Test::Exception;
use Test::Mock::Guard;
use Capture::Tiny ':all';

sub create_crenv {
    my (%opt) = @_;

    require Crenv;
    require Crenv::Fetcher::Wget;

    $opt{fetcher}     ||= Crenv::Fetcher::Wget->new;
    $opt{github_repo} ||= 'author/repo';
    $opt{prefix}      ||= 't/tmp/.crenv';

    setup_dirs();
    Crenv->new(%opt);
}

sub setup_dirs {
    require File::Path;
    import File::Path qw/rmtree mkpath/;

    rmtree('t/tmp/.crenv');
    mkpath('t/tmp/.crenv');
}

our @EXPORT = (
    qw/create_crenv/,

    @Data::Dumper::EXPORT,

    @Test::More::EXPORT,
    @Test::Deep::EXPORT,
    @Test::Deep::Matcher::EXPORT,
    @Test::Exception::EXPORT,
    @Test::Mock::Guard::EXPORT,
    @Capture::Tiny::EXPORT_OK,
);

1;
