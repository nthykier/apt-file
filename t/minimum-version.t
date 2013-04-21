#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;
eval 'use Test::MinimumVersion';
plan skip_all => 'Test::MinimumVersion required to run this test' if $@;

# sarge was released with 5.8.4, etch with 5.8.8, lenny with 5.10.0
our $REQUIRED = 'v5.10.0';
all_minimum_version_ok($REQUIRED, { paths => ['.'] , no_plan => 1});

done_testing();
