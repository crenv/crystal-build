package SemVer::V2::Strict;
use strict;
use warnings;
use utf8;

our $VERSION = '0.04';

use constant PRE_RELEASE_FORMAT    => qr/(?:-(?<pre_release>[a-zA-Z0-9.\-]+))?/;
use constant BUILD_METADATA_FORMAT => qr/(?:\+(?<build_metadata>[a-zA-Z0-9.\-]+))?/;
use constant VERSION_FORMAT        =>
    qr/(?<major>[0-9]+)(?:\.(?<minor>[0-9]+))?(?:\.(?<patch>[0-9]+))?@{[PRE_RELEASE_FORMAT]}@{[BUILD_METADATA_FORMAT]}/;

use List::Util qw/min max/;
use Scalar::Util qw/looks_like_number/;

use overload (
    q{""}    => \&as_string,
    q{<=>}   => \&_cmp,
    fallback => 1,
);

sub major          { shift->{major} }
sub minor          { shift->{minor} }
sub patch          { shift->{patch} }
sub pre_release    { shift->{pre_release} }
sub build_metadata { shift->{build_metadata} }

sub new {
    my $class = shift;
    my $self  = bless {} => $class;

    $self->_init_by_version_numbers     if @_ == 0;
    $self->_init_by_version_string(@_)  if @_ == 1;
    $self->_init_by_version_numbers(@_) if @_ >= 2;

    return $self;
}

sub _init_by_version_string {
    my ($self, $version) = @_;

    die 'Invalid format' unless $version =~ VERSION_FORMAT;

    $self->{major}          = $+{major};
    $self->{minor}          = $+{minor} // 0;
    $self->{patch}          = $+{patch} // 0;
    $self->{pre_release}    = $+{pre_release};
    $self->{build_metadata} = $+{build_metadata};
}

sub _init_by_version_numbers {
    my ($self, $major, $minor, $patch, $pre_release, $build_metadata) = @_;

    $self->{major}          = $major // 0;
    $self->{minor}          = $minor // 0;
    $self->{patch}          = $patch // 0;
    $self->{pre_release}    = $pre_release;
    $self->{build_metadata} = $build_metadata;
}

sub as_string {
    my $self = shift;

    my $string = $self->major.'.'.$self->minor.'.'.$self->patch;
    $string .= '-'.$self->pre_release    if $self->pre_release;
    $string .= '+'.$self->build_metadata if $self->build_metadata;

    return $string;
}

sub _cmp {
    my ($self, $other) = @_;

    return $self->major <=> $other->major if $self->major != $other->major;
    return $self->minor <=> $other->minor if $self->minor != $other->minor;
    return $self->patch <=> $other->patch if $self->patch != $other->patch;
    return _compare_pre_release($self->pre_release, $other->pre_release);
}

sub _compare_pre_release {
    my ($a, $b) = @_;

    return  1 if !defined $a && $b;
    return -1 if $a && !defined $b;

    if ($a && $b) {
        my @left  = split /-|\./, $a;
        my @right = split /-|\./, $b;
        my $max   = max(scalar @left, scalar @right);

        for (my $i = 0; $i < $max; ++$i) {
            my $a = $left[$i]  // 0;
            my $b = $right[$i] // 0;

            if (looks_like_number($a) && looks_like_number($b)) {
                return $a <=> $b if $a != $b;
            }

            my $min = min(length $a, length $b);
            for (my $n = 0; $n < $min; ++$n) {
                my $c = substr($a, $n, 1) cmp substr($b, $n, 1);
                return $c if $c != 0;
            }
        }
    }

    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

SemVer::V2::Strict - Semantic version v2.0 object for Perl

=head1 SYNOPSIS

    use SemVer::V2::Strict;

    my $v1 = SemVer::V2::Strict->new('1.0.2');
    my $v2 = SemVer::V2::Strict->new('2.0.0-alpha.10');

    if ($v1 < $v2) {
        print "$v1 < $v2\n"; # => '1.0.2 < 2.0.0-alpha.10'
    }

=head1 DESCRIPTION

This module subclasses version to create semantic versions, as defined by the L<Semantic Versioning 2.0.0|http://semver.org/spec/v2.0.0.html> Specification.

=head1 METHODS

=head2 CLASS METHODS

=head3 C<new()>

Create new empty C<SemVer::V2::Strict> instance.
C<SemVer::V2::Strict-E<gt>new()> equals C<SemVer::V2::Strict-E<gt>new('0.0.0')>.

=head3 C<new($version_string)>

Create new C<SemVer::V2::Strict> instance from a version string.
C<SemVer::V2::Strict-E<gt>new('1.0.0')> equals C<SemVer::V2::Strict-E<gt>new(1, 0, 0)>.

=head3 C<new($major, $minor = 0, $patch = 0, $pre_release = undef, $build_metadata = undef)>

Create new C<SemVer::V2::Strict> instance from version numbers.
C<SemVer::V2::Strict-E<gt>new('1.0.0-alpha+100')> equals C<SemVer::V2::Strict-E<gt>new(1, 0, 0, 'alpha', '100')>.

=head2 METHODS

=head3 C<major>

Get the major version number.

=head3 C<minor>

Return the minor version number.

=head3 C<patch>

Return the patch version number.

=head3 C<pre_release>

Return the pre_release string.

=head3 C<build_metadata>

Return the build_metadata string.

=head3 C<E<lt>=E<gt>>

Compare two C<SemVer::V2::Strict> instances.

=head3 C<"">

Convert a C<SemVer::V2::Strict> instance to string.

=head1 SEE ALSO

=over

=item * L<SemVer>

=item * L<version>

=back

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2015 Pine Mizune

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 ACKNOWLEDGEMENT

C<SemVer::V2::Strict> is based from rosylilly's L<semver|https://github.com/rosylilly/semver>.
Thank you.

=head1 AUTHOR

Pine Mizune E<lt>pinemz@gmail.comE<gt>

=cut

