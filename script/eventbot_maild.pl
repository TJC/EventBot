#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use IO::File;
use File::Slurp;
use File::Spec;
use File::HomeDir;

warn "This script is deprecated in favour of eventbot_fetchmail.pl\n";
sleep 5;

# TODO: Move logfile to EventBot::Log or something, and use config file
# to determine where/what to log to it..
my $logfile = File::Spec->catfile(File::HomeDir->my_home, 'eventbot.log');
my $log = IO::File->new($logfile, 'a')
    or die("Unable to open logfile: $!");

my $email = read_file(\*STDIN);
my $bot = EventBot->new(
    logfile => $log,
);
$bot->parse_email($email);
$log->close;

exit(0);
