# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More tests => 2;
use Test::WWW::Mechanize::Catalyst 'EventBot::WWW';

# TODO: This test needs some serious improvements!

ok( my $mech = Test::WWW::Mechanize::Catalyst->new, 'Created mech object' );

$mech->get_ok( 'http://localhost/people/top' );


