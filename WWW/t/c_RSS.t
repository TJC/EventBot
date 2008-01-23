use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'EventBot::WWW' }
BEGIN { use_ok 'EventBot::WWW::C::RSS' }

ok( request('/rss')->is_success, 'Request should succeed' );


