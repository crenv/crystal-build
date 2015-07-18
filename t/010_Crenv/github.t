use strict;
use warnings;
use utf8;

use t::Util;

subtest basic => sub {
    my $self = create_crenv;
    isa_ok $self->github, 'Crenv::GitHub';
    is $self->github->{fetcher}, $self->{fetcher};
    is $self->github->{github_repo}, $self->{github_repo};
};

done_testing;
