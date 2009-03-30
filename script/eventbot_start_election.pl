#!/usr/bin/perl
use strict;
use warnings;
use feature ':5.10';
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot::Schema;
use Getopt::Long;
use MIME::Lite;

my ($dbname, $user) = qw(eventbot eventbot);
my ($help, $sendmail);
GetOptions(
    'database=s' => \$dbname,
    'user=s' => \$user,
    'sendmail' => \$sendmail,
    'help' => \$help,
);

if ($help) {
    print qq{
Start an election.
Params:
  --database=eventbot  which DB to use.
  --user=db_user       which DB user.
  --sendmail       send a mail to the list.
    };
    exit 1;
}

my $schema = EventBot::Schema->connect("dbi:Pg:dbname=$dbname", $user)
    or die("Failed to connect to DB!");

my $e = $schema->resultset('Elections')->commence;

my $body = sprintf('A new election (%d) has started!', $e->id);
$body .= "\nThe candidates are:\n";

my $vcount = 0;
for my $p ($e->candidates) {
    my $letter = chr($vcount++ + ord('A'));
    $body .= sprintf('    %s -- %s (%s)', $letter, $p->name, $p->region)
          . "\n";
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


my $mail = MIME::Lite->new(
    From => 'eventbot@dryft.net',
    To   => ($sendmail ? 'sluts@twisted.org.uk' : 'dryfter@gmail.com'),
    Subject => 'Pub election for ' . next_thursday()->dmy,
    Data => $body
);
if ($sendmail) {
    $mail->send;
}
else {
    say $mail->as_string;
}



sub next_thursday {
    my $date = DateTime->now();
    while ($date->day_of_week != 4) {
        $date->add(days => 1);
    }
    return $date;
}

