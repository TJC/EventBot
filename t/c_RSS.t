# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;

Test::EventBot->schema; # Deploys schema

use_ok('Catalyst::Test', 'EventBot::WWW');

use_ok('EventBot::WWW::Controller::RSS');

ok( request('/rss/upcoming')->is_success, 'RSS feed live');

done_testing();
