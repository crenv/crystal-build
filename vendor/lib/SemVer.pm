package SemVer;

use 5.008001;
use strict;
use version 0.82;
use Scalar::Util ();

use overload (
    '""'   => 'stringify',
    '<=>'  => 'vcmp',
    'cmp'  => 'vcmp',
);

our @ISA = qw(version);
our $VERSION = '0.6.0'; # For Module::Build

sub _die { require Carp; Carp::croak(@_) }

# Prevent version.pm from mucking with our internals.
sub import {}

# Adapted from version.pm.
my $STRICT_INTEGER_PART = qr/0|[1-9][0-9]*/;
my $STRICT_DOTTED_INTEGER_PART = qr/\.$STRICT_INTEGER_PART/;
my $STRICT_DOTTED_INTEGER_VERSION =
    qr/ $STRICT_INTEGER_PART $STRICT_DOTTED_INTEGER_PART{2,} /x;
my $OPTIONAL_EXTRA_PART = qr/[a-zA-Z][-0-9A-Za-z]*/;

sub new {
    my ($class, $ival) = @_;

    # Handle vstring.
    return $class->SUPER::new($ival) if Scalar::Util::isvstring($ival);

    # Let version handle cloning.
    if (eval { $ival->isa('version') }) {
        my $self = $class->SUPER::new($ival);
        $self->{extra} = $ival->{extra};
        $self->{dash}  = $ival->{dash};
        return $self;
    }

    my ($val, $dash, $extra) = (
        $ival =~ /^v?($STRICT_DOTTED_INTEGER_VERSION)(?:(-)($OPTIONAL_EXTRA_PART))?$/
    );
    _die qq{Invalid semantic version string format: "$ival"}
        unless defined $val;

    my $self = $class->SUPER::new($val);
    $self->{dash}  = $dash;
    $self->{extra} = $extra;
    return $self;
}

$VERSION = __PACKAGE__->new($VERSION); # For ourselves.

sub declare {
    my ($class, $ival) = @_;
    return $class->new($ival) if Scalar::Util::isvstring($ival)
        or eval { $ival->isa('version') };

    (my $v = $ival) =~ s/(?:(-?)($OPTIONAL_EXTRA_PART))[[:space:]]*$//;
    my $dash  = $1;
    my $extra = $2;
    $v += 0 if $v =~ s/_//g; # ignore underscores.
    my $self = $class->SUPER::declare($v);
    $self->{dash}  = $dash;
    $self->{extra} = $extra;
    return $self;
}

sub parse {
    my ($class, $ival) = @_;
    return $class->new($ival) if Scalar::Util::isvstring($ival)
        or eval { $ival->isa('version') };

    (my $v = $ival) =~ s/(?:(-?)($OPTIONAL_EXTRA_PART))[[:space:]]*$//;
    my $dash  = $1;
    my $extra = $2;
    $v += 0 if $v =~ s/_//g; # ignore underscores.
    my $self = $class->SUPER::parse($v);
    $self->{dash}  = $dash;
    $self->{extra} = $extra;
    return $self;
}

sub stringify {
    my $self = shift;
    my $str = $self->SUPER::stringify;
    # This is purely for SemVers constructed from version objects.
    $str += 0 if $str =~ s/_//g; # ignore underscores.
    return $str . ($self->{dash} || '') . ($self->{extra} || '');
}

sub normal   {
    my $self = shift;
    (my $norm = $self->SUPER::normal) =~ s/^v//;
    $norm =~ s/_/./g;
    return $norm . ($self->{extra} ? "-$self->{extra}" : '');
}

sub numify   { _die 'Semantic versions cannot be numified'; }
sub is_alpha { !!shift->{extra} }

sub vcmp {
    my $left  = shift;
    my $right = ref($left)->declare(shift);

    # Reverse?
    ($left, $right) = shift() ? ($right, $left): ($left, $right);

    # Major and minor win.
    if (my $ret = $left->SUPER::vcmp($right, 0)) {
        return $ret;
    } else {
        # They're equal. Check the extra text stuff.
        if (my $l = $left->{extra}) {
            my $r = $right->{extra} or return -1;
            return lc $l cmp lc $r;
        } else {
            return $right->{extra} ? 1 : 0;
        }
    }
}

1;
__END__

=head1 Name

SemVer - Use semantic version numbers

=head1 Synopsis

  use SemVer; our $VERSION = SemVer->new('1.2.0b1');

=head1 Description

This module subclasses L<version> to create semantic versions, as defined by
the L<Semantic Versioning 1.0.0 Specification|http://semver.org/spec/v1.0.0.html>.
The two salient points of the specification, for the purposes of version
formatting, are:

=over

=item 1.

A normal version number MUST take the form X.Y.Z where X, Y, and Z are
integers. X is the major version, Y is the minor version, and Z is the patch
version. Each element MUST increase numerically by increments of one. For
instance: C<< 1.9.0 < 1.10.0 < 1.11.0 >>.

=item 2.

A pre-release version number MAY be denoted by appending an arbitrary string
immediately following the patch version and a dash. The string MUST be
comprised of only alphanumerics plus dash C<[0-9A-Za-z-]>. Pre-release
versions satisfy but have a lower precedence than the associated normal
version. Precedence SHOULD be determined by lexicographic ASCII sort order. For
instance: C<< 1.0.0-alpha1 < 1.0.0-beta1 < 1.0.0-beta2 < 1.0.0-rc1 < 1.0.0 >>.

=back

=head2 Usage

For strict parsing of semantic version numbers, use the C<new()> constructor.
If you need something more flexible, use C<declare()>. And if you need
something more comparable with what L<version> expects, try C<parse()>.
Compare how these constructors deal with various version strings (with values
shown as returned by C<normal()>:

    Argument  | new      | declare     | parse
 -------------+----------+---------------------------
  '1.0.0'     | 1.0.0    | 1.0.0       | 1.0.0
  '5.5.2-b1'  | 5.5.2-b1 | 5.5.2-b1    | 5.5.2-b1
  '1.05.0'    | <error>  | 1.5.0       | 1.5.0
  '1.0'       | <error>  | 1.0.0       | 1.0.0
  '  012.2.2' | <error>  | 12.2.2      | 12.2.2
  '1.1'       | <error>  | 1.1.0       | 1.100.0
   1.1        | <error>  | 1.1.0       | 1.100.0
  '1.1.0b1'   | <error>  | 1.1.0-b1    | 1.1.0-b1
  '1.1-b1'    | <error>  | 1.1.0-b1    | 1.100.0-b1
  '1.2.b1'    | <error>  | 1.2.0-b1    | 1.2.0-b1
  '9.0-beta4' | <error>  | 9.0.0-beta4 | 9.0.0-beta4
  '9'         | <error>  | 9.0.0       | 9.0.0
  '1-b'       | <error>  | 1.0.0-b     | 1.0.0-b
   0          | <error>  | 0.0.0       | 0.0.0
  '0-rc1'     | <error>  | 0.0.0-rc1   | 0.0.0-rc1
  '1.02_30'   | <error>  | 1.23.0      | 1.23.0
   1.02_30    | <error>  | 1.23.0      | 1.23.0

Note that, unlike in L<version>, the C<declare> and C<parse> methods ignore
underscores. That is, version strings with underscores are treated as decimal
numbers. Hence, the last two examples yield exactly the same semantic
versions.

As with L<version> objects, the comparison and stringification operators are
all overloaded, so that you can compare semantic versions. You can also
compare semantic versions with version objects (but not the other way around,
alas). Boolean operators are also overloaded, such that all semantic version
objects except for those consisting only of zeros are considered true.

=head1 Interface

=head2 Constructors

=head3 C<new>

  my $semver = SemVer->new('1.2.2');

Performs a validating parse of the version string and returns a new semantic
version object. If the version string does not adhere to the semantic version
specification an exception will be thrown. See C<declare> and C<parse> for
more forgiving constructors.

=head3 C<declare>

  my $semver = SemVer->declare('1.2'); # 1.2.0

This parser strips out any underscores from the version string and passes it
to to C<version>'s C<declare> constructor, which always creates dotted-integer
version objects. This is the most flexible way to declare versions. Consider
using it to normalize version strings.

=head3 C<parse>

  my $semver = SemVer->parse('1.2'); # 1.200.0

This parser dispatches to C<version>'s C<parse> constructor, which tries to be
more flexible in how it converts simple decimal strings and numbers. Not
really recommended, since it's treatment of decimals is quite different from
the dotted-integer format of semantic version strings, and thus can lead to
inconsistencies. Included only for proper compatibility with L<version>.

=head2 Instance Methods

=head3 C<normal>

  SemVer->declare('v1.2')->normal;       # 1.2.0
  SemVer->parse('1.2')->normal;          # 1.200.0
  SemVer->declare('1.02.0-b1')->normal;  # 1.2.0-b1
  SemVer->parse('1.02_30')->normal       # 1.230.0
  SemVer->parse(1.02_30)->normal         # 1.23.0

Returns a normalized representation of the version. This string will always be
a strictly-valid dotted-integer semantic version string suitable for passing
to C<new()>. Unlike L<version>'s C<normal> method, there will be no leading
"v".

=head3 C<stringify>

  SemVer->declare('v1.2')->stringify;    # v1.2
  SemVer->parse('1.200')->stringify;     # v1.200
  SemVer->declare('1.2-r1')->stringify;  # v1.2-r1
  SemVer->parse(1.02_30)->stringify;     # v1.0230
  SemVer->parse(1.02_30)->stringify;     # v1.023

Returns a string that is as close to the original representation as possible.
If the original representation was a numeric literal, it will be returned the
way perl would normally represent it in a string. This method is used whenever
a version object is interpolated into a string.

=head3 C<numify>

Throws an exception. Semantic versions cannot be numified. Just don't go
there.

=head3 C<is_alpha>

  my $is_alpha = $semver->is_alpha;

Returns true if an ASCII string is appended to the end of the version string.
This also means that the version number is a "special version", in the
semantic versioning specification meaning of the phrase.

=head3 C<vcmp>

Compares the semantic version object to another version object or string and
returns 0 if they're the same, -1 if the invocant is smaller than the
argument, and 1 if the invocant is greater than the argument.

Mostly you don't need to worry about this: Just use the comparison operators
instead. They will use this method:

  if ($semver < $another_semver) {
      die "Need $another_semver or higher";
  }

Note that in addition to comparing other semantic version objects, you can
also compare regular L<version> objects:

  if ($semver < $version) {
      die "Need $version or higher";
  }

You can also pass in a version string. It will be turned into a semantic
version object using C<declare>. So if you're using integer versions, you may
or may not get what you want:

  my $semver  = version::Semver->new('1.2.0');
  my $version = '1.2';
  my $bool    = $semver == $version; # true

If that's not what you want, pass the string to C<parse> first:

  my $semver  = version::Semver->new('1.2.0');
  my $version = version::Semver->parse('1.2'); # 1.200.0
  my $bool    = $semver == $version; # false

=head1 See Also

=over

=item * L<Semantic Versioning Specification|http://semver.org/>.

=item * L<version>

=item * L<version::AlphaBeta>

=back

=head1 Support

This module is managed in an open
L<GitHub repository|http://github.com/theory/semver/>. Feel free to fork and
contribute, or to clone L<git://github.com/theory/semver.git> and send
patches!

Found a bug? Please L<post|http://github.com/theory/semver/issues> or
L<email|mailto:bug-semver@rt.cpan.org> a report!

=head1 Acknowledgements

Many thanks to L<version> author John Peacock for his suggestions and
debugging help.

=head1 Authors

David E. Wheeler <david@kineticode.com>

=head1 Copyright and License

Copyright (c) 2010-2015 David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
