package Crenv::Resolver;
use strict;
use warnings;
use utf8;

use Crenv::Resolver::GitHub;

sub get {
    my ($class, $type) = @_;

    $type eq 'github' ? Crenv::Fetcher::GitHub->new :
    die 'Resolver type invalid';
}

1;
