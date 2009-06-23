package EventBot::MailParser::Votes;
use strict;
use warnings;

sub parse {
    my ($class, $subject, $body) = @_;
    my @commands;
    my @lines = split("\n", $body);
    foreach my $line (@lines) {
        # Detect election votes:
        if (my @votes = $line =~
            /^
            \s*
            I\svote\s*:\s*
            ([A-Za-z])\s*
            ([A-Za-z])?\s*
            ([A-Za-z])?\s*
            ([A-Za-z])?\s*
            /x
        ) {
            warn "Found votes: " . join(', ', @votes) . "\n";
            push(@commands, {
                type => 'vote',
                votes => \@votes,
            });
        }
    }

    return @commands;
}

1;
