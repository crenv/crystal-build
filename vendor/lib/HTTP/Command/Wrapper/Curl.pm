package HTTP::Command::Wrapper::Curl;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, $opt) = @_;
    return bless { opt => $opt } => $class;
}

sub fetch_able {
    my ($self, $url, $headers) = @_;

    `curl -LIs @{[$self->_headers($headers)]} "$url"` =~ m/200 OK/;
}

sub fetch {
    my ($self, $url, $headers) = @_;

    `curl -Ls @{[$self->_headers($headers)]} "$url"`;
}

sub download {
    my ($self, $url, $path, $headers) = @_;

    system("curl -L @{[$self->_headers($headers)]} \"$url\" -o \"$path\"") == 0;
}

sub _headers {
    my ($self, $headers) = @_;
    $headers = [] unless defined $headers;

    return join(' ', map { "-H \"$_\"" } @$headers);
}

1;
