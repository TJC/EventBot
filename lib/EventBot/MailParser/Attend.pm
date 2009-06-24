package EventBot::MailParser::Attend;
use strict;
use warnings;

=head1 NAME

EventBot::MailParser::Attend

=head1 SYNOPSIS

Mail parser module for event attendance emails.

ie. Where the subject line is [Event 1234] and the body contains something
like:

  +Your Name (optional comment)

=cut

sub parse {
    my ($class, $subject, $body) = @_;

    my ($event_id) = $subject =~ /\[event (\d+)\]/i;
    return() unless $event_id;

    my @commands;
    my @lines = split("\n", $body);

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
