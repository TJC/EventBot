use strict;
use warnings;
use Test::More tests => 2;
use Test::WWW::Mechanize::Catalyst 'EventBot::WWW';

# Another very lame test, sorry.. This needs some Event Fixtures and proper
# tests to see if event details are visible, etc.

my $mech = Test::WWW::Mechanize::Catalyst->new;

$mech->get_ok( '/event/list' );

$mech->get_ok( '/event/pastlist' );

