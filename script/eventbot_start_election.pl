#!/usr/local/strategic/perl/bin/perl
use 5.16.0;
use warnings;
use Getopt::Long;
use DateTime;
use Email::Simple;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP qw();
use Try::Tiny;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use EventBot::Mailer;

my ($help, $sendmail);
GetOptions(
    'sendmail' => \$sendmail,
    'help' => \$help,
);

if ($help) {
    print qq{
Start an election.
Params:
  --sendmail       Actually send a mail to the list.
    };
    exit 1;
}

my $bot = EventBot->new;
my $schema = $bot->schema;

my $thursday = next_thursday();
my @specEvents = $schema->resultset('SpecialEvents')
    ->search(
        {
            date => $schema->storage->datetime_parser->format_datetime($thursday),
            confirmed => 1
        }
    );
my @extraPubs = map { $_->pub } @specEvents;

my $e = $schema->resultset('Elections')->commence({ extra => \@extraPubs });

my $body = sprintf(
    'A new election (%d) has started!%sThis is for Thursday %s',
    $e->id, "\n", $thursday->dmy
);
$body .= "\n\nThe candidates are:\n";

my $vcount = 0;
for my $p ($e->candidates) {
    my $letter = chr($vcount++ + ord('A'));
    $body .= sprintf('    %s -- %s (%s)', $letter, $p->name, $p->region)
          . "\n";
    # Also show the URL, if there is one:
    if ($p->info_uri) {
        $body .= sprintf('         %s', $p->info_uri) . "\n"
    }
}

if (@specEvents) {
    $body .= "\nThis list also includes special event(s):\n";
    for my $event (@specEvents) {
        $body .= sprintf(' * %s\'s %s at the %s.',
            $event->person->name, $event->comment, $event->pub->name
        ) . "\n";
    }
}

my $e_id = $e->id;
$body .= qq{

To vote, please send an email either directly to me, or to the list, which
says:
I vote: X Y Z

Where X Y Z are actually A B C etc, ordered in descending preference.

You can keep track of votes (and the result) at:
http://eventbot.dryft.net/election/$e_id/result

Thanks,
VoteBot

};

if ($sendmail) {
    my $mailer = EventBot::Mailer->new;
    $mailer->mailout(
        $body,
        Subject => 'Pub election for ' . $thursday->dmy,
    );
}
else {
    say " ** TEST MODE ** Not really sending mail to anyone!";
    say $body;
}



sub next_thursday {
    my $date = DateTime->now();
    while ($date->day_of_week != 4) {
        $date->add(days => 1);
    }
    return $date;
}

