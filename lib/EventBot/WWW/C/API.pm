package EventBot::WWW::C::API;
use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::C::API

=head1 DESCRIPTION

Controller for API calls.

Currently all API calls accept parameters via GET or POST, and return data
in JSON format.

=head1 METHODS

=cut

=head2 api

Head of the chain for the API calls.

Sets the view to be JSON for all subsequent steps in the chain.

=cut

sub api :Chained PathPart CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'JSON';
}

=head2 api_info

Returns HTML info about the API.

=cut

sub api_info :Chained PathPart('api') Args(0) {
    my ($self, $c) = @_;
    # Just returns HTML describing the API for now..
}

=head2 election_candidates

For path /api/election_candidates

This returns an array of current election candidates..

=cut

sub election_candidates :Chained('api') PathPart Args(0) {
    my ($self, $c) = @_;
    my $election = $c->model('DB::Elections')->latest;
    $c->detach('/fourohfour') unless $election;

    $c->stash->{response} = {
        election => { id => $election->id },
        candidates => [],
        status => ($election->enabled ? 'active' : 'inactive'),
    };
    return unless $election;

    $c->stash->{response}{candidates} = [
        map {
                {
                    id => $_->id,
                    name => sprintf('%s (%s)', $_->name, $_->region),
                }
        } $election->candidates
    ];
}

=head2 current_events

For path /api/current_events

This returns a list of events occuring in the next 6 days.

=cut

sub current_events :Chained('api') PathPart Args(0) {
    my ($self, $c) = @_;

    my $events = $c->model('DB::Events')->search(
        {},
        {
            where => qq{
                startdate >= (CURRENT_TIMESTAMP - '1 day'::INTERVAL)
                AND startdate <= (CURRENT_TIMESTAMP + '6 days'::INTERVAL)
            },
            order_by => 'startdate'
        }
    );
    $c->stash->{response} = [map { _serialise_event($_) } $events->all];
}

=head2 _serialise_event

Converts an event object into a serialisable hash of data.

=cut

sub _serialise_event {
    my $event = shift;
    return {
        map { $_ => $event->$_ } qw(id startdate starttime place url comments)
    };
}

=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
# vim: sw=4 sts=4 et tw=75 wm=5
