package CrystalBuild::Resolver::Utils;
use strict;
use warnings;
use utf8;

use SemVer::V2::Strict;

sub sort_version {
    my ($self, $versions) = @_;
    return [ sort {
        SemVer::V2::Strict->new($a) <=> SemVer::V2::Strict->new($b)
    } @$versions ];
}

sub normalize_version {
    my ($self, $v) = @_;

    die 'version is required' unless $v;

    return $v if $v =~ m/^\d+\.?(\d+|x)?\.?(\d+|x)?$/;
    return do { $v =~ s/v//; $v } if $v =~ m/^v\d+\.?(\d+|x)?\.?(\d+|x)?$/;
    return $v;
}

1;
