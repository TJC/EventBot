#!/usr/bin/env perl
# vim: sw=4 sts=4 et tw=75 wm=5

## Run Perl::Critic against the source code and the tests
## Requires TEST_CRITIC to be set

use strict;
use warnings;
use Test::More;

eval "use Test::Perl::Critic;";
if ($@) {
    plan skip_all => 'Test::Perl::Critic required for this test.';
}

unless ($ENV{TEST_CRITIC}) {
    plan skip_all => 'Set the environment variable TEST_CRITIC to enable this test';
}

all_critic_ok('lib');
