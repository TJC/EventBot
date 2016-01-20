#!/usr/bin/env perl
##!/usr/local/strategic/perl/bin/perl
use 5.16.0;
use warnings;
use Email::Simple;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP qw();
use Getopt::Long;
use DateTime;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use EventBot::Mailer;

my ($help, $sendmail, $election_id);
GetOptions(
    'sendmail' => \$sendmail,
    'election' => \$election_id,
    'help' => \$help,
);

if ($help) {
    print qq{
Start an election.
Params:
  --election=123       Which election to tally up (otherwise latest)
  --sendmail       send a mail to the list.
    };
    exit 1;
}

my $thursday = next_thursday();

my $bot = EventBot->new;
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

# Check if that pub was a special event:
my $birthday = $schema->resultset('SpecialEvents')->search(
    {
        date => $schema->storage->datetime_parser->format_datetime($thursday),
        pub => $pub->id,
        confirmed => 1,
    }
)->next;

my %event_details;
my @body;
push @body, 'We have a winner:';
push @body, sprintf('Place: %s (%s)', $pub->name, $pub->region);
$event_details{place} = sprintf('Place: %s (%s)', $pub->name, $pub->region);
if ($pub->name !~ /none of the above/i) {
    push @body, "Date: " . $thursday->dmy;
    $event_details{date} = $thursday->dmy;

    push @body, "Time: Evening";
    $event_details{time} = "Evening";

    push @body, 'Address: ' . $pub->street_address;
    $event_details{address} = $pub->street_address;

    if ($pub->info_uri) {
        push @body, 'URL: ' . $pub->info_uri;
        $event_details{url} = $pub->info_uri;
    }
}

push @body, '';
if ($birthday) {
    my $comment = sprintf('This is %s\'s special event - %s.',
        $birthday->person->name, $birthday->comment
    );
    push @body, $comment;
    $event_details{comment} = $comment;
}
push @body, 'If you hate the venue, remember it was endorsed by:';
push @body, join(' and ', map { $_->name } $pub->nominees);

push @body, '';
push @body, 'Vote tallies:';

# Display tallies:
for my $r (@results) {
    push @body, sprintf('%s has a score of %d:',
                $r->pub->name, $r->get_column('pub_score')
            );
    my @voters = $schema->resultset('Votes')->search(
        {
            election => $e->id,
            pub => $r->pub->id
        }
    );
    for my $v (@voters) {
        push(@body,
            sprintf(' * %s (%d points)',
                $v->person->name, (5 - $v->rank) * 2
            )
        );
    }
}

push @body, '';
push @body, sprintf(
    'For more info, see http://eventbot.dryft.net/election/%d/result',
    $e->id
);

if ($sendmail) {
    my $mailer = EventBot::Mailer->new;

    $mailer->mailout(
        join("\n", @body),
        Subject => 'Election results for ' . $thursday->dmy,
    );

    $bot->do_newevent(\%event_details);
}
else {
    say " ** TEST MODE ** Not really sending mail to anyone!";
    say "-==================================================-";
    say join("\n", @body);
}


sub next_thursday {
    my $date = DateTime->now();
    while ($date->day_of_week != 4) {
        $date->add(days => 1);
    }
    return $date;
}
