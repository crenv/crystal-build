package HTTP::Command::Wrapper::Wget;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, $opt) = @_;
    return bless { opt => $opt } => $class;
}

sub fetch_able {
    my ($self, $url, $headers) = @_;

    `wget @{[$self->_headers($headers)]} -Sq --spider "$url" 2>&1` =~ m/200 OK/;
}

sub fetch {
    my ($self, $url, $headers) = @_;

    `wget @{[$self->_headers($headers)]} -q $url -O -`;
}

sub download {
    my ($self, $url, $path, $headers) = @_;

    system(qq{wget -c @{[$self->_headers($headers)]} "$url" -O "$path"}) == 0;
}

sub _headers {
    my ($self, $headers) = @_;
    $headers = [] unless defined $headers;

    return join(' ', map { "--header=\"$_\"" } @$headers);
}

1;
