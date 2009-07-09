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

my $logfile = File::Spec->catfile(File::HomeDir->my_home, 'eventbot.log');
my $log = IO::File->new($logfile, 'a')
    or die("Unable to open logfile: $!");

my $email = read_file(\*STDIN);
my $bot = EventBot->new({
    logfile => $log,
    config => 'eventbot.cfg',
});
$bot->parse_email($email);
$log->close;

exit(0);
