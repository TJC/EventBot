# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More tests => 2;
use Catalyst::Test 'EventBot::WWW';

use_ok('EventBot::WWW::C::RSS');

ok( request('/rss/upcoming')->is_success, 'RSS feed live');


