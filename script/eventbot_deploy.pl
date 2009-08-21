#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use EventBot;

if (not @ARGV or $ARGV[0] =~ /help/i) {
    die("Deploys database manually.\nUsage: deploy.pl dbname\n");
}

my $dbname = shift @ARGV;
my $user = shift(@ARGV) || 'eventbot';

system('createdb', '--encoding=utf8', $dbname);

# If your DB isn't on localhost use:
# EventBot::Schema->connect("dbi:Pg:dbname=$dbname;host=YOUR_DB_HOST_HERE", $user)
# And if you have password auth setup:
# EventBot::Schema->connect("dbi:Pg:dbname=$dbname;host=192.168.1.162", $user, 'PASSWORD')
my $bot = EventBot->new({
    config => ($ENV{EVENTBOT_CONFIG} || 'eventbot.cfg'),
});

my $schema = $bot->schema;

$schema->deploy;

print "Successfully deployed to $dbname\n";

1;
