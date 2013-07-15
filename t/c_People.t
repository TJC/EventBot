# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;

# TODO: This test needs some serious improvements!

my $mech = Test::EventBot->mech;

$mech->get_ok( 'http://localhost/people/top' );

done_testing();
