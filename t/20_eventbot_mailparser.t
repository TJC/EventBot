#!/usr/bin/perl
# vim: sw=4 sts=4 et tw=75 wm=5
use strict;
use warnings;
use Test::More;
use File::Slurp qw(slurp);
use Data::Dumper;

use_ok('EventBot::MailParser') or die;

# Test new events:
{
    my $newevent_text = slurp('t/newevent.txt');
    my $parser = EventBot::MailParser->new;
    $parser->parse($newevent_text);
    # diag(Dumper($parser->commands));
    is_deeply(
        $parser->commands,
        [ {
            type => 'newevent',
            time => '19:00 GMT onwards',
            date => '2006-11-23',
            place => 'The Anchor, 34 Park Street, Bankside, Southwark, London, SE1 9EF',
            comments => 'http://www.beerintheevening.com/pubs/show.shtml/1638',
            anddo => 'list sluts tarts expire 24/11/2006',
        } ],
        "Locate new event in email"
    );
}
{
    my $newevent_text = slurp('t/newevent2.txt');
    my $parser = EventBot::MailParser->new;
    $parser->parse($newevent_text);
    diag(Dumper($parser->commands));
    is_deeply(
        $parser->commands,
        [ {
            type => 'newevent',
            time => 'Evening',
            date => '19-11-2009',
            place => 'The Edinboro Castle (Camden)',
            url => 'http://www.beerintheevening.com/pubs/show.shtml/1009',
            address => '57 Mornington Terrace, London, NW1 7RU',
        } ],
        "Located new event from election"
    );
}

# Test attendance to an event:
{
    my $attend_text = slurp('t/attend.txt');
    my $parser = EventBot::MailParser->new;
    $parser->parse($attend_text);
    my $commands = $parser->commands;
    # diag(Dumper($commands));
    # Skip the newevent that is also usually created:
    my @attends = grep { $_->{type} eq 'attend' } @$commands;
    is_deeply(
        \@attends,
        [{
            type => 'attend',
            mode => '+',
            name => 'Wintrmute (blah)',
            event => 123,
        }],
        "Found attendance command in plaintext email"
    );
}

# Test attendance to an event, in a MIME-encoded email:
{
    my $attend_mime = slurp('t/attend_mime.txt');
    my $parser = EventBot::MailParser->new;
    $parser->parse($attend_mime);
    # diag(Dumper($parser->commands));
    is_deeply(
        $parser->commands,
        [{
            type => 'attend',
            mode => '+',
            name => 'Simon C',
            event => 205,
        }],
        "Found attendance command in MIME encoded email"
    );
}

# Test attendance to an event, in a multi-part html email:
{
    my $attend_mime = slurp('t/attend_html.txt');
    my $parser = EventBot::MailParser->new;
    $parser->parse($attend_mime);
    # diag(Dumper($parser->commands));
    is_deeply(
        $parser->commands,
        [{
            type => 'attend',
            mode => '-',
            name => 'Wintrmute (testing HTML emails)',
            event => 204,
        }],
        "Found attendance command in multi-part HTML email"
    );
}

# Test vote emails:
my %votes = (
    'vote.txt' => [qw(A B C E)],
    'vote_1.txt' => [qw(D A B)],
    'vote_2.txt' => [qw(B)],
    'vote_3.txt' => [qw(D C B)],
    'vote_4.txt' => [qw(E)],
);
while (my ($file, $results) = each %votes) {
    my $attend_mime = slurp("t/$file");
    my $parser = EventBot::MailParser->new;
    $parser->parse($attend_mime);
    # diag(Dumper($parser->commands));
    is_deeply(
        $parser->commands,
        [{
            type => 'vote',
            votes => $results,
        }],
        "Found correct votes in email $file"
    );
}

done_testing;
