# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl EventBot.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('EventBot') };

#########################

use_ok('Email::Simple');
my $text = `cat t/newevent.txt`;

my $email = Email::Simple->new($text);

my $eventbot = EventBot->new;
$eventbot->parse_email($email);


$text = `cat t/attend.txt`;
$email = Email::Simple->new($text);

my $eventbot = EventBot->new;
$eventbot->parse_email($email);

