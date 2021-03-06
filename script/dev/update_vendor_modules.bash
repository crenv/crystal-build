#!/bin/bash

set -xe

cd `git rev-parse --show-toplevel`

LOCAL_LIB=local/lib/perl5
VENDOR_LIB=vendor/lib

rm -rf $VENDOR_LIB
mkdir -p $VENDOR_LIB

# parent
cp -rf $LOCAL_LIB/parent.pm $VENDOR_LIB/parent.pm

# Class::Accessor::Lite
mkdir -p $VENDOR_LIB/Class/Accessor
cp -rf $LOCAL_LIB/Class/Accessor/Lite.pm $VENDOR_LIB/Class/Accessor/Lite.pm

# File::Which
mkdir -p $VENDOR_LIB/File
cp -rf $LOCAL_LIB/File/Which.pm $VENDOR_LIB/File/Which.pm

# HTTP::Command::Wrapper
mkdir -p $VENDOR_LIB/HTTP/Command
cp -rf $LOCAL_LIB/HTTP/Command/Wrapper    $VENDOR_LIB/HTTP/Command/Wrapper
cp -rf $LOCAL_LIB/HTTP/Command/Wrapper.pm $VENDOR_LIB/HTTP/Command/Wrapper.pm

# JSON::PP
mkdir -p $VENDOR_LIB/JSON
cp -rf $LOCAL_LIB/JSON/PP    $VENDOR_LIB/JSON/PP
cp -rf $LOCAL_LIB/JSON/PP.pm $VENDOR_LIB/JSON/PP.pm

# Mac::OSVersion::Lite
mkdir -p $VENDOR_LIB/Mac/OSVersion
cp -rf $LOCAL_LIB/Mac/OSVersion/Lite.pm $VENDOR_LIB/Mac/OSVersion/Lite.pm

# SemVer::V2::Strict
mkdir -p $VENDOR_LIB/SemVer/V2
cp -rf $LOCAL_LIB/SemVer/V2/Strict.pm $VENDOR_LIB/SemVer/V2/Strict.pm

# Text::Camel
mkdir -p $VENDOR_LIB/Text
cp -rf $LOCAL_LIB/Text/Caml.pm $VENDOR_LIB/Text/Caml.pm
