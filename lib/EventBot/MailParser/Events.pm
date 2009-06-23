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
    # TODO: Bring over the event detection routines

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
                      data => {
                          name => $name,
                          mode => $mode,
                          event => $event_id,
                      }
                  }
              );
        }
    }
    return \@commands;
}

1;
