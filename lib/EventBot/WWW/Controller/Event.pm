# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::Event;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::Controller::Event - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

list upcoming events

=cut

sub list :Local {
    my ($self, $c) = @_;

    my $events = $c->model('DB::Events')->search(
        {
            startdate => {'>=', 'now()'}
        },
        { order_by => 'startdate' });
    $c->stash->{events} = $events;
}

=head2 pastlist

list past events

=cut

sub pastlist :Local {
    my ($self, $c) = @_;

    my $events = $c->model('DB::Events')->search(
        {
            startdate => {'<=', 'now()'}
        },
        { order_by => 'startdate DESC' });
    $c->stash->{events} = $events;
}

=head view

view this event's details

=cut

sub view :Local {
    my ($self, $c, $id) = @_;

    my $event = $c->model('DB::Events')->find($id);
    $c->stash->{event} = $event;
    $c->stash->{attendees} = $event->search_related('attendees',
        undef, { order_by => 'status DESC' });
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
