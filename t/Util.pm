package t::Util;

use strict;
use warnings;
use utf8;
use feature qw/state/;

use File::Basename qw/dirname/;
use lib (
    dirname(__FILE__)."/../vendor/lib",
    dirname(__FILE__)."/../lib"
);

use Exporter 'import';
use Data::Dumper;
use Cwd qw/abs_path/;

use Test::More;
use Test::Deep;
use Test::Deep::Matcher;
use Test::Exception;
use Test::Mock::Guard;

sub create_crenv {
    my (%opt) = @_;

    require Crenv;
    require Crenv::Fetcher::Wget;

    $opt{fetcher}     ||= Crenv::Fetcher::Wget->new;
    $opt{github_repo} ||= 'author/repo';
    $opt{prefix}      ||= 't/tmp/.crenv/versions/0.7.4';
    $opt{cache}       ||= 1;
    $opt{cache_dir}   ||= abs_path('t/tmp/.crenv/cache');
    $opt{cache_url}   ||= 'http://example.com/releases';

    setup_dirs();
    Crenv->new(%opt);
}

sub setup_dirs {
    require File::Path;
    import File::Path qw/rmtree mkpath/;

    rmtree('t/tmp') if -d 't/tmp';
    mkpath('t/tmp/.crenv');
}

sub create_server {
    state $server;
    return $server if defined $server;

    require Test::TCP;
    require Plack::Loader;
    require Plack::Middleware::Static;

    my $app = sub {
        my $env = shift;

        Plack::Middleware::Static->new({
            path => sub { 1 },
            root => 't/data/',
        })->call($env);
    };

    $server = Test::TCP->new(
        code => sub {
            my $port   = shift;
            my $server = Plack::Loader->auto(
                port => $port,
                host => '127.0.0.1',
            );
            $server->run($app);
        },
    );

    return $server;
}

sub uri_for {
    my $path = shift;
    my $port = create_server()->port;

    return "http://127.0.0.1:$port/$path";
}

our @EXPORT = (
    qw/create_crenv create_server setup_dirs uri_for/,

    @Data::Dumper::EXPORT,

    @Test::More::EXPORT,
    @Test::Deep::EXPORT,
    @Test::Deep::Matcher::EXPORT,
    @Test::Exception::EXPORT,
    @Test::Mock::Guard::EXPORT,
);

1;
