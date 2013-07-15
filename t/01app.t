# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;

BEGIN { use_ok 'Catalyst::Test', 'EventBot::WWW' }

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
