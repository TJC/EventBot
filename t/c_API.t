# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'EventBot::WWW';
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;
use Fixture::Pub;
use DateTime;
use JSON::XS;

=head1 WARNING

This test is a bit flawed; EventBot::Test connects to a temp DB, but
EventBot::WWW still connects to the DB in the eventbot.yml file.

Will fix later. -Toby

=cut

my $tomorrow = DateTime->today->add(days => 1)->ymd;

ok($ENV{EVENTBOT_TEST}, "Testing environment enabled") or die;

# Causes database to be deployed!
my $schema = Test::EventBot->schema;
my $mech = Test::WWW::Mechanize::Catalyst->new;

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
diag("Current events = " . $mech->content) unless $ENV{HARNESS_ACTIVE};
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
diag($mech->content) unless $ENV{HARNESS_ACTIVE};
my $candidates = decode_json($mech->content);
ok($candidates->{election}{id}, "Retrieved election ID");

done_testing();
