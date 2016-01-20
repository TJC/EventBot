#!/usr/bin/env perl
##!/usr/local/strategic/perl/bin/perl
use 5.16.0;
use warnings;
use Net::IMAP::Simple;
use Email::Simple;
use Try::Tiny;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;

my $bot = EventBot->new;

my $imap = Net::IMAP::Simple->new(
    'imap.gmail.com',
    port => $bot->config->{imap}{port},
    use_ssl => $bot->config->{imap}{use_ssl},
    timeout => 30,
);

die("Failed to IMAP login: " . $imap->errstr . "\n")
  unless(
    $imap->login($bot->config->{imap}{email}, $bot->config->{imap}{passwd})
  );

warn "That's weird, default mailbox is not INBOX.\n"
  unless ($imap->current_box eq 'INBOX');

my $nm = $imap->select('INBOX');
# They appear to be ordered in order of arrival, which is good.
for my $i (1 .. $nm) {
    my $message = $imap->get($i) or die $imap->errstr;

    try {
        my $email = Email::Simple->new("$message");
        print $email->header('Date') . "\t==\t";
        say $email->header('Subject');

        $bot->parse_email("$message");
    }
    catch {
        warn "Failed to parse email: $_\n";
    };
    try {
        $imap->delete($i) or die $imap->errstr;
    }
    catch {
        warn "Failed to delete message $i: $_\n";
    };

}

$imap->quit;
