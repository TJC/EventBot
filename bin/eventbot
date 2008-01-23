#!/usr/bin/perl
use strict;
use warnings;
use lib qw{
   /home/tjc/eventbot/EventBot/lib 
};
use EventBot;
use Email::Simple;
use IO::File;
use File::Slurp;

my $log = IO::File->new('/home/tjc/eventbot.log', 'a')
    or die("Unable to open logfile: $!");

my $body = read_file(\*STDIN);
my $email = Email::Simple->new($body);
my $bot = EventBot->new({logfile => $log});
$bot->parse_email($email);
$log->close;

exit(0);
