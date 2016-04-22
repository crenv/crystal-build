package Mac::OSVersion::Lite;
use strict;
use warnings;
use utf8;

our $VERSION = "0.02";

use constant VERSION_FORMAT    => qr/(?<major>[0-9]+)(?:\.(?<minor>[0-9]+))?(?:\.(?<point>[0-9]+))?/;
use constant MAC_VERSION_NAMES => {
    el_capitan    => "10.11",
    yosemite      => "10.10",
    mavericks     => "10.9",
    mountain_lion => "10.8",
    lion          => "10.7",
    snow_leopard  => "10.6",
    leopard       => "10.5",
    tiger         => "10.4",
};

use overload (
    q{""}    => \&as_string,
    q{<=>}   => \&_cmp,
    fallback => 1,
);

sub major { shift->{major} }
sub minor { shift->{minor} }

sub new {
    my $class = shift;
    my $self  = bless {} => $class;

    $self->_init_by_current_version     if @_ == 0;
    $self->_init_by_version_string(@_)  if @_ == 1;
    $self->_init_by_version_numbers(@_) if @_ >= 2;

    return $self;
}

sub _init_by_current_version {
    my $self    = shift;
    my $command = '/usr/bin/sw_vers -productVersion';
    my $version = `$command`;

    die "Command \`$command\` failed: $version (exit code: $?)\n" if $? != 0;

    $self->_init_by_version_string($version);
}

sub _init_by_version_string {
    my ($self, $string) = @_;

    if (defined MAC_VERSION_NAMES->{$string}) {
        $string = MAC_VERSION_NAMES->{$string};
    }

    die "Invalid format: $string\n" unless $string =~ qr/^@{[VERSION_FORMAT]}$/;

    $self->{major} = $+{major};
    $self->{minor} = $+{minor} // 0;
}

sub _init_by_version_numbers {
    my ($self, $major, $minor) = @_;

    $self->{major} = $major // 0;
	$self->{minor} = $minor // 0;
}

sub name {
    my $self = shift;
    my %map  = reverse %{ MAC_VERSION_NAMES() };
    return $map{$self->as_string};
}

sub as_string {
    my $self = shift;
    return $self->{major}.'.'.$self->{minor};
}

sub _cmp {
    my ($self, $other) = @_;

    return $self->{major} <=> $other->{major} if $self->{major} != $other->{major};
    return $self->{minor} <=> $other->{minor};
}

1;
__END__

=encoding utf-8

=head1 NAME

Mac::OSVersion::Lite - It's the lightweight version object for Mac OS X

=head1 SYNOPSIS

    use Mac::OSVersion::Lite;
    use feature qw/say/;

    my $version = Mac::OSVersion::Lite->new;
    say $version->major; # 10
    say $version->minor; # 11
    say $version->name;  # el_capitan

=head1 DESCRIPTION

Mac::OSVersion::Lite is the lightweight version object for Mac OS X with auto detection.

=head1 METHODS

=head2 CLASS METHODS

=head3 C<new()>

Create new C<Mac::OSVersion::Lite> instance with auto detection.

=head3 C<new($version_string)>

Create new C<Mac::OSVersion::Lite> instance from a version string.
C<Mac::OSVersion::Lite-E<gt>new('10.11')> equals C<Mac::OSVersion::Lite-E<gt>new(10, 11)>.

=head3 C<new($major, $minor = 0)>

Create new C<Mac::OSVersion::Lite> instance from version numbers.
C<Mac::OSVersion::Lite-E<gt>new(10, 11)> equals C<Mac::OSVersion::Lite-E<gt>new('10.11')>.

=head2 METHODS

=head3 C<major>

Get the major version number.

=head3 C<minor>

Return the minor version number.

=head3 C<E<lt>=E<gt>>

Compare two C<SemVer::V2::Strict> instances.

=head3 C<"">

Convert a C<SemVer::V2::Strict> instance to string.

=head3 C<as_string()>

Convert a C<SemVer::V2::Strict> instance to string.

=head1 SEE ALSO

=over

=item * L<Mac::OSVersion>

=back

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2016 Pine Mizune

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

=head1 AUTHOR

Pine Mizune E<lt>pinemz@gmail.comE<gt>

=cut

