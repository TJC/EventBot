#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
use File::Slurp qw(slurp);
use Data::Dumper;

use_ok('EventBot::MailParser') or die;

#########################

use_ok('Email::Simple');
my $newevent_text = slurp('t/newevent.txt');

my $parser = EventBot::MailParser->new;
$parser->parse($newevent_text);
diag(Dumper($parser->commands));

my $attend_text = slurp('t/attend.txt');
my $parser2 = EventBot::MailParser->new;
$parser2->parse($attend_text);
diag(Dumper($parser2->commands));


my $attend_mime = slurp('t/attend_mime.txt');
my $parser3 = EventBot::MailParser->new;
$parser3->parse($attend_mime);
diag(Dumper($parser3->commands));

