# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::MailParser::NewEvent;
use strict;
use warnings;

sub parse {
    my ($class, $subject, $body) = @_;
    my %vars; # for events..

    my @lines = split("\n", $body);
    for my $line (@lines) {
        # Detect events:
        if (my ($key, $val) = $line =~
          /^
            \s*
            (\w{2,8})
            :\s+
            ([[:print:]]+)
          $/x
        ) {
            $val =~ s/\s*$//;
            $key = lc($key);
            $vars{$key} = $val;
        }
    }

    if ( $vars{'date'} and $vars{'time'} and $vars{'place'} ) {
        # Don't pass on a "type" var:
        delete $vars{type};
        return({
            type => 'newevent',
            %vars,
        });
    }
    return;
}

1;
