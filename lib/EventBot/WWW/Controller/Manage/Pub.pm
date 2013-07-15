# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::Manage::Pub;
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
    $c->stash->{template} = 'manage/pub/endorse.tt';

    # I really, really need to fix the table to identify "real" users
    # another way.. So start with potential users..
    my @pot_users = $c->model('DB::People')->search(
        {},
        # { \[ 'length(email) <> 32' ] },
        { order_by => 'name' },
    );
    $c->stash->{all_users} = [
        grep { $_->email !~ /^[0-9a-f]{32}$/ } @pot_users
    ];

    $c->stash->{all_admins} = $c->model('DB::Admins')->search(
        { active => 1 },
        { order_by => 'name' },
    );

    # Figure out current endorsers:
    $c->stash->{current_endorsers} = [
        map { $_->id } $c->stash->{pub}->nominees
    ];

    return unless ($c->request->method =~ /post/i
        and $c->request->params->{admin} =~ /^\d+$/
    );

    my $admin = $c->model('DB::Admins')->search(
        {
            id => $c->request->params->{admin},
            password => $c->request->params->{pw}
        }
    )->next;

    unless ($admin) {
        $c->stash->{message} = 'Incorrect admin password';
        return;
    }

    $c->model('DB')->schema->txn_do(sub {
        $admin->create_related('logs', {
            action => "Adjusted endorsements on pub: "
                . $c->stash->{pub}->name
        });

        $c->stash->{pub}->search_related('endorsements')->delete;

        for my $i (1..2) {
            my $eid = $c->request->params->{"endorser$i"};
            next if ($eid eq 'DELETE');
            next unless ($eid =~ /^\d+$/);
            $c->stash->{pub}->create_related('endorsements',
                {
                    pub => $c->stash->{pub}->id,
                    person => $eid,
                }
            );
        }

        my $e_count = $c->model('DB::Endorsements')->search(
            { pub => $c->stash->{pub}->id }
        )->count;

        # Require at least two endorsements to be endorsed:
        $c->stash->{pub}->endorsed( $e_count >= 2 ? 1 : 0 );
        $c->stash->{pub}->update;
    });

    $c->stash->{message} = 'Saved!';
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
