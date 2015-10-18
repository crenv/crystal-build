package Crenv::Fetcher::Curl;
use strict;
use warnings;
use utf8;

sub new {
    my $class = shift;
    bless {} => $class;
}

sub fetch_able {
    my ($self, $url) = @_;

    `curl -LIs "$url"` =~ m/200 OK/;
}

sub fetch {
    my ($self, $url) = @_;

    `curl -Ls $url`;
}

sub fetch_from_github {
    my ($self, $url) = @_;

    `curl -H 'Accept: application/vnd.github.v3+json' -Ls $url`;
}

sub download {
    my ($self, $url, $path) = @_;

    system("curl -LSs $url -o $path") == 0;
}

1;
