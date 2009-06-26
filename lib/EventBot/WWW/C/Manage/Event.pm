package EventBot::WWW::C::Manage::Event;
use strict;
use warnings;
use parent 'Catalyst::Controller';

# This module should contain methods to create a one-off event for eventbot,
# which dispatches a confirmation email, and after that immediately submits the
# event.

sub event : Chained('/manage/manage_base') PathPart CaptureArgs(0) {
    my ($self, $c) = @_;
    # base event creation..
}

sub create :Chained('event') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{nominees} = $c->model('DB::People')->search(
        {},
        { order_by => 'name' }
    );
    $c->stash->{venues} = $c->model('DB::Pubs')->search(
        {},
        { order_by => 'name' }
    );
    return unless $c->request->method =~ /^POST/i;
}

1;
