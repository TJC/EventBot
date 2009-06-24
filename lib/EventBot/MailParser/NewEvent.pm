package EventBot::MailParser::NewEvent;
use strict;
use warnings;

sub parse {
    my ($class, $subject, $body) = @_;

    my @commands;
    my @lines = split("\n", $body);
    # TODO: Bring over the old event detection routines (ie. by name instead of
    # using the subject line's event id)

    for my $line (@lines) {
    }
    return @commands;
}

1;

