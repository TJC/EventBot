#!/usr/bin/perl
use strict;
use warnings;
use Test::More 'no_plan';
use FindBin;
use lib "$FindBin::Bin";
use Test::EventBot;
use File::Slurp qw(slurp);
use File::Temp qw(:seekable);
use IO::File;
use Data::Dumper;

#
# Test the main EventBot package.
# (Sorry, not very complete at the moment!!)
# (But it does exercise all the functions..)
#

# Causes database to be deployed!
my $schema = Test::EventBot->schema;

use_ok('EventBot') or die;
ok($ENV{EVENTBOT_TEST}, "Testing environment enabled");

my $bot = EventBot->new({
    logfile => File::Temp->new,
    config => Test::EventBot->config_file,
});

# Test new events:
{
    my $newevent_text = slurp('t/newevent.txt');
    $bot->parse_email($newevent_text);
}

# Test attendance to an event:
{
    my $attend_text = slurp('t/attend.txt');
    $bot->parse_email($attend_text);
}

# Test attendance to an event, in a MIME-encoded email:
{
    my $attend_mime = slurp('t/attend_mime.txt');
    $bot->parse_email($attend_mime);
}

# Test attendance to an event, in a multi-part html email:
{
    my $attend_html = slurp('t/attend_html.txt');
    $bot->parse_email($attend_html);
}

# Test a vote:
{
    my $voter = slurp('t/vote.txt');
    $bot->parse_email($voter);
}
