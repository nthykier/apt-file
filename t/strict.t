#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;
eval 'use Test::Strict';
plan skip_all => 'Test::Strict required to run this test' if $@;

all_perl_files_ok();
