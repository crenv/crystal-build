package CrystalBuild::Homebrew;
use CrystalBuild::Sense;

use Class::Accessor::Lite (
    new => 1,
);

sub exists {
    my ($self, $formula) = @_;
    my $list     = `brew list`;
    my @formulas = grep { $_ } split(/\s+/, $list);

    return !! grep { $_ eq $formula } @formulas;
}

sub install {
    my ($self, $formula) = @_;

    unless ($self->exists($formula)) {
        say "Installing $formula by Homebrew";
        return system("brew install $formula") == 0;
    }

    return 1; # already installed
}

1;
__END__
