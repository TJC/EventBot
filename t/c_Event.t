# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;

# Another very lame test, sorry.. This needs some Event Fixtures and proper
# tests to see if event details are visible, etc.

my $mech = Test::EventBot->mech;

$mech->get_ok( '/event/list' );

$mech->get_ok( '/event/pastlist' );

done_testing();
