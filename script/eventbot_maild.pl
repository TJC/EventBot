#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;
use IO::File;
use File::Slurp;
use File::Spec;
use File::HomeDir;

# TODO: Move logfile to EventBot::Log or something, and use config file
# to determine where/what to log to it..
my $logfile = File::Spec->catfile(File::HomeDir->my_home, 'eventbot.log');
my $log = IO::File->new($logfile, 'a')
    or die("Unable to open logfile: $!");

my $email = read_file(\*STDIN);
my $bot = EventBot->new({
    logfile => $log,
    config => ($ENV{EVENTBOT_CONFIG} || 'eventbot.cfg'),
});
$bot->parse_email($email);
$log->close;

exit(0);
