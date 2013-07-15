# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;
use Fixture::Pub;
use DateTime;
use JSON::XS;

my $tomorrow = DateTime->today->add(days => 1)->ymd;

ok($ENV{EVENTBOT_TEST}, "Testing environment enabled") or die;

# Causes database to be deployed!
my $schema = Test::EventBot->schema;

my $mech = Test::EventBot->mech;

# Create an event:
$schema->resultset('Events')->create(
    {
        startdate => $tomorrow,
        starttime => '7 pm',
        place => 'The testing quarter (Nowhere)',
        url => 'http://example.com',
        comments => 'foo bar baby!'
    }
);

$mech->get_ok('/api');

$mech->get_ok( '/api/current_events' );
note("Current events = " . $mech->content);
my $event = decode_json($mech->content);
is($event->[0]->{comments}, 'foo bar baby!', "Event comments returned");


# Add some test pubs..
for (1..10) {
    my $pub = Fixture::Pub->new;
    $pub->update({ endorsed => 1 });
}
# Start an election:
$schema->resultset('Elections')->commence;

$mech->get_ok( '/api/election_candidates' );
note($mech->content);
my $candidates = decode_json($mech->content);
ok($candidates->{election}{id}, "Retrieved election ID");

done_testing();
