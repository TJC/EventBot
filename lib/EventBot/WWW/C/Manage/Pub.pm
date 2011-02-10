# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::C::Manage::Pub;
use Moose;
use namespace::autoclean;
use EventBot::Form::Pub;
use EventBot::Geocode;

BEGIN { extends 'Catalyst::Controller'; }

has 'form' => (
    isa => 'EventBot::Form::Pub',
    is => 'rw',
    lazy => 1,
    default => sub { EventBot::Form::Pub->new },
);

# This module should contain methods to edit, nominate, endorse pubs.
# Note that the *other* Pub.pm already contains methods to list and view pub
# details, so I'm just going to chain off there for the extra methods, I
# think..

sub endorse : Chained('/pub/pub_name') PathPart Args(0) {
    my ($self, $c) = @_;

}

sub create : Path('/manage/pub/create') {
    my ($self, $c) = @_;
    $c->stash->{pub} = $c->model('DB::Pubs')->new_result({});
    $c->forward('edit');
}

sub edit : Chained('/pub/pub_name') PathPart Args(0) {
    my ($self, $c) = @_;

    $c->stash->{form} = $self->form;
    $c->stash->{template} = 'manage/pub/edit.tt';

    if ($c->stash->{pub}->name =~ /None of the above/i) {
        $c->stash->{message} = 'Not allowed to edit meta-pubs!';
        return;
    }

    return unless $self->form->process(
        item => $c->stash->{pub},
        params => $c->request->params,
        action => $c->request->uri->path,
    );

    my $pub = $c->stash->{pub};
    eval {
        my $g = EventBot::Geocode->new;
        my $loc = $g->address($pub->street_address);
        $pub->update($loc);
    };
    if ($@) {
        my $err = sprintf('Failed to geocode pub %s (%d) at %s: %s%s',
            $pub->name, $pub->id, $pub->street_address,
            $@
        );
        $c->log->error($err);
    }

    $c->response->redirect($c->stash->{pub}->url_to_self);
    $c->response->body('Redirecting..');
}

1;
