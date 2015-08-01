package Crenv::Resolver::Cache::Local;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, %opt) = @_;
    return bless { %opt } => $class;
}

1;
