package Crenv::Fetcher::Wget;
use strict;
use warnings;
use utf8;

sub new {
    my $class = shift;
    bless {} => $class;
}

sub fetch_able {
    my ($self, $url) = @_;

    `wget -Sq --spider "$url" 2>&1` =~ m/200 OK/;
}

sub fetch {
    my ($self, $url) = @_;

    `wget -q $url -O -`;
}

sub fetch_from_github {
    my ($self, $url) = @_;

    `wget -q $url --header='Accept: application/vnd.github.v3+json' -O -`;
}

sub download {
    my ($self, $url, $path) = @_;

    system("wget -c $url -O $path") == 0;
}

1;
