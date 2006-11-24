package EventBot::WWW::C::People;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::C::People - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 top 

Show top attendees

=cut

sub top :Local {
    my ( $self, $c ) = @_;

    my $query = {
            select => [
                'person',
                { count => 'person' }
            ],
            as => [qw/person count/],
            group_by => ['person'],
            order_by => 'count DESC',
            rows => 10,
    };

    $c->stash->{attendees} = $c->model('Attendees')->search(
        { 'status' => 'Yes', }, $query
    );
    $c->stash->{absentees} = $c->model('Attendees')->search(
        { 'status' => 'No', }, $query
    );
    $c->stash->{unknown} = $c->model('Attendees')->search(
        { 'status' => 'Maybe', }, $query
    );
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
