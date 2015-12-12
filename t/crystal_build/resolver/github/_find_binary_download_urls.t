use strict;
use warnings;
use utf8;

use t::Util;

use CrystalBuild::Resolver::GitHub;

subtest 'if < v0.7.5' => sub {
    # 64 bit releases only
    my $assets = [
        {
            name                 => 'crystal-0.7.5-1-darwin-x86_64.tar.gz',
            browser_download_url => 'http://www.example.com/darwin/x64',
        },
        {
            name                 => 'crystal-0.7.5-1-linux-x86_64.tar.gz',
            browser_download_url => 'http://www.example.com/linux/x64',
        },
    ];

    my $urls = CrystalBuild::Resolver::GitHub->_find_binary_download_urls($assets);
    is $urls->{'darwin-x64'}, 'http://www.example.com/darwin/x64';
    is $urls->{'linux-x64'}, 'http://www.example.com/linux/x64';
    ok not defined $urls->{'linux-x86'};
};

subtest basic => sub {
    my $assets = [
        {
            name                 => 'crystal-0.7.5-1-darwin-x86_64.tar.gz',
            browser_download_url => 'http://www.example.com/darwin/x64',
        },
        {
            name                 => 'crystal-0.7.5-1-linux-x86_64.tar.gz',
            browser_download_url => 'http://www.example.com/linux/x64',
        },
        {
            name                 => 'crystal-0.7.5-1-linux-i686.tar.gz',
            browser_download_url => 'http://www.example.com/linux/x86',
        },
    ];

    my $urls = CrystalBuild::Resolver::GitHub->_find_binary_download_urls($assets);
    is $urls->{'darwin-x64'}, 'http://www.example.com/darwin/x64';
    is $urls->{'linux-x64'}, 'http://www.example.com/linux/x64';
    is $urls->{'linux-x86'}, 'http://www.example.com/linux/x86';
};

done_testing;
