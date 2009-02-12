#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use Email::Simple;
use IO::File;
use File::Slurp;
use File::Spec;
use File::HomeDir;

my $logfile = File::Spec->catfile(File::HomeDir->my_home, 'eventbot.log');
my $log = IO::File->new($logfile, 'a')
    or die("Unable to open logfile: $!");

my $body = read_file(\*STDIN);
my $email = Email::Simple->new($body);
my $bot = EventBot->new({logfile => $log});
$bot->parse_email($email);
$log->close;

exit(0);
