package EventBot::Utils;
use strict;
use warnings;

=head1 NAME

EventBot::Utils - Utility functions used in multiple EventBot modules.

=cut

=head2 figure_date

What a stupid subroutine name I gave this.

it's supposed to take a string, and figure out what format it was written in,
and return that as a DateTime object.

It dies if it can't figure anything out! Perhaps it should just return undef?

=cut

sub figure_date {
    my $class = shift; # Unused
    my $date = shift;

    if ($date =~ m{^(\d{1,2})[-/](\d{1,2})[-/](\d\d\d\d)$}) {
        return DateTime->new(
            year => $3,
            month => $2,
            day => $1
        );
    }

    if ($date =~ /^(\d\d\d\d)\-(\d{1,2})\-(\d{1,2})$/) {
        return DateTime->new(
            year => $1,
            month => $2,
            day => $3
        );
    }

    die("Invalid date: $date");
}

1;
