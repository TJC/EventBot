package EventBot::MailParser::Events;
use strict;
use warnings;

sub parse {
    my ($class, $subject, $body) = @_;
    my $event_id;

    if ($subject =~ /\[event (\d+)\]/i) {
        $event_id = $1;
        warn "Suspected event ID: $event_id\n";
    }
    my @commands;
    my @lines = split("\n", $body);
    # TODO: Bring over the old event detection routines (ie. by name instead of
    # using the subject line's event id)

    for my $line (@lines) {
        if (my($mode, $name) = $line =~
              /^\s*
              ([-\+\?])
              \s*
              [`']?
              ([\w\d][[:print:]]+?)
              [`']?
              \s*$
              /x
          ) {
              push(@commands, {
                      type => 'attend',
                      name => $name,
                      mode => $mode,
                      event => $event_id,
                  }
              );
        }
    }
    return @commands;
}

1;
