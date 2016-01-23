package HTTP::Command::Wrapper;
use strict;
use warnings;
use utf8;

our $VERSION = "0.04";

use File::Which qw/which/;

use HTTP::Command::Wrapper::Curl;
use HTTP::Command::Wrapper::Wget;

sub create {
    my $class = shift;
    my $opt   = {};
    my $type  = undef;

    $opt = $_[0] if ref $_[0] eq 'HASH';
    $opt = $_[1] if ref $_[1] eq 'HASH';

    $type = $_[0] unless ref $_[0];
    $type = $class->_detect_type unless defined $type;

    return HTTP::Command::Wrapper::Curl->new($opt) if $type eq 'curl';
    return HTTP::Command::Wrapper::Wget->new($opt) if $type eq 'wget';

    die 'Command not detected (curl or wget)';
}

sub _detect_type {
    my $class = shift;

    return 'curl' if $class->_which('curl');
    return 'wget' if $class->_which('wget');
    return undef;
}

sub _which { which($_[1]) }

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Command::Wrapper - The command based HTTP client (wget/curl wrapper). Too minimum dependencies!

=head1 SYNOPSIS

    use HTTP::Command::Wrapper;

    my $client  = HTTP::Command::Wrapper->create; # auto detecting (curl or wget)
    my $content = $client->fetch('https://github.com/');

    print "$content\n";

=head1 DESCRIPTION

HTTP::Command::Wrapper is a very simple HTTP client module.
It can wrap C<wget> or C<curl> command, and can use same interface.

=head1 METHODS

=head2 CLASS METHODS

=head3 C<create()>

Create new wrapper instance using automatic commands detecting.

=head3 C<create($type)>

Create new wrapper instance. C<'wget'> or C<'curl'> can be specified as C<$type> value.

=head2 METHODS

=head3 C<fetch($url, $headers = [])>

Fetch http/https contents from C<$url>. Return a content body as string.

=head3 C<fetch_able($url, $headers = [])>

Return true if C<$url> contents can fetch (status code is C<200>).

=head3 C<download($url, $path, $headers = [])>

Fetch http/https contents from C<$url>. Save in file. Return process exit code as boolean.

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2015 Pine Mizune

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=head1 AUTHOR

Pine Mizune E<lt>pinemz@gmail.comE<gt>

=cut

