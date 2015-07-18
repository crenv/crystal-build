package Crenv::GitHub;
use strict;
use warnings;
use utf8;

use JSON::PP;

sub new {
    my ($class, %opt) = @_;

    my $self = +{ %opt };
    bless $self => $class;
}

sub fetch {
    my ($self, $url) = @_;
    $self->{fetcher}->fetch_from_github($url);
}

sub base_url {
    my $self = shift;
    'https://api.github.com/repos/' . $self->{github_repo} . '/';
}

sub fetch_as_json {
    my ($self, $path) = @_;

    my $url      = $self->base_url . $path;
    my $content  = $self->fetch($url);
    decode_json($content);
}

sub fetch_release {
    my ($self, $version) = @_;
    $self->fetch_as_json('releases/tags/' . $version);
}

sub fetch_releases {
    my ($self) = @_;
    $self->fetch_as_json('releases?per_page=100');
}

1;
