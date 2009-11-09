#!/usr/bin/perl
use strict;
use warnings;
use feature ':5.10';
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use Getopt::Long;
use MIME::Lite;
use DateTime;

my ($dbname, $user) = qw(eventbot eventbot);
my $bot = EventBot->new({
	    config => ($ENV{EVENTBOT_CONFIG} || 'eventbot.cfg'),
});
my ($help, $sendmail, $election_id);
GetOptions(
    'database=s' => \$dbname,
    'user=s' => \$user,
    'sendmail' => \$sendmail,
    'election' => \$election_id,
    'help' => \$help,
);

if ($help) {
    print qq{
Start an election.
Params:
  --database=eventbot  which DB to use.
  --user=db_user       which DB user.
  --election=123       Which election to tally up (otherwise latest)
  --sendmail       send a mail to the list.
    };
    exit 1;
}

my $thursday = next_thursday();

my $schema = $bot->schema;

my $e;
if ($election_id ) {
    $e = $schema->resultset('Elections')->get($election_id)
}
else {
    $e = $schema->resultset('Elections')->latest()
        or die("No current election found!\n");
}

my @results = $e->conclude; # Finish the election and get vote tallies!


my $pub = $e->winner;
my @body;
push @body, 'We have a winner:';
push @body, sprintf('Place: %s (%s)', $pub->name, $pub->region);
if ($pub->name !~ /none of the above/i) {
    push @body, "Date: " . next_thursday()->dmy;
    push @body, "Time: Evening";
    push @body, 'Address: ' . $pub->street_address;
    if ($pub->info_uri) {
        push @body, 'URL: ' . $pub->info_uri;
    }
}
push @body, '';
push @body, 'If you hate it, remember it was endorsed by:';
push @body, join(' and ', map { $_->name } $pub->nominees);

push @body, '';
push @body, 'Vote tallies:';

# Display tallies:
for my $r (@results) {
    push @body, sprintf('%s has %d votes:',
                $r->pub->name, $r->get_column('pub_count')
            );
    my @voters = $schema->resultset('Votes')->search(
        {
            election => $e->id,
            pub => $r->pub->id
        }
    );
    for my $v (@voters) {
        push @body, ' * ' . $v->person->name;
    }
}

push @body, '';
push @body, sprintf(
    'For more info, see http://eventbot.dryft.net/election/%d/result',
    $e->id
);


my $mail = MIME::Lite->new(
    From => $bot->from_addr,
    To   => $bot->list_addr,
    Subject => 'Election results for ' . next_thursday()->dmy,
    Data => join("\n", @body),
);

if ($sendmail) {
    $mail->send;
}
else {
    say " ** TEST MODE ** Not really sending mail to anyone!";
    say $mail->as_string;
}



sub next_thursday {
    my $date = DateTime->now();
    while ($date->day_of_week != 4) {
        $date->add(days => 1);
    }
    return $date;
}
