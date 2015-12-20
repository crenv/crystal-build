#!/bin/bash

set -xe

cd `git rev-parse --show-toplevel`

LOCAL_LIB=local/lib/perl5
VENDOR_LIB=vendor/lib

rm -rf $VENDOR_LIB
mkdir -p $VENDOR_LIB

mkdir -p $VENDOR_LIB/File
cp -rf $LOCAL_LIB/File/Which.pm $VENDOR_LIB/File/Which.pm

mkdir -p $VENDOR_LIB/HTTP/Command
cp -rf $LOCAL_LIB/HTTP/Command/Wrapper    $VENDOR_LIB/HTTP/Command/Wrapper
cp -rf $LOCAL_LIB/HTTP/Command/Wrapper.pm $VENDOR_LIB/HTTP/Command/Wrapper.pm

mkdir -p $VENDOR_LIB/JSON
cp -rf $LOCAL_LIB/JSON/PP    $VENDOR_LIB/JSON/PP
cp -rf $LOCAL_LIB/JSON/PP.pm $VENDOR_LIB/JSON/PP.pm

mkdir -p $VENDOR_LIB/SemVer/V2
cp -rf $LOCAL_LIB/SemVer/V2/Strict.pm $VENDOR_LIB/SemVer/V2/Strict.pm

