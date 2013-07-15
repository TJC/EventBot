# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::Manage::SpecialEvent;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use MIME::Lite;
use EventBot::Utils;
use feature ':5.10';

=head1 SYNOPSIS

Allow viewing or creation of special events ("birthday pubs").
They still require people to vote upon them before being turned into full
eventbot events.

=cut

sub specialevent : Chained('/manage/manage_base') PathPart CaptureArgs(0) {
    my ($self, $c) = @_;

}

sub specialevent_list :Chained('specialevent') PathPart('list') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{events} = $c->model('DB::SpecialEvents')->search(
        { confirmed => 1 },
        { order_by => 'DATE' }
    );
}

sub specialevent_create :Chained('specialevent') PathPart('create') Args(0) {
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

    eval {
        my $date = EventBot::Utils->figure_date($c->request->params->{date})
            or die("Invalid date\n");
        my $nom = $c->model('DB::People')->find($c->request->params->{nominee})
            or die("Unknown nominee\n");
        my $pub = $c->model('DB::Pubs')->find($c->request->params->{venue})
            or die("Unknown pub\n");
        my $comment = $c->request->params->{comment};
        $comment =~ s/</&lt;/g;
        $comment =~ s/>/&gt;/g;
        die("Comment too long!\n") if length($comment) > 250;

        $c->stash->{event} = $c->model('DB::SpecialEvents')->create(
            {
                person => $nom->id,
                pub => $pub->id,
                date => $date,
                comment => $comment
            }
        );
        $c->stash->{confirm} = $c->model('DB::Confirmations')->create(
            {
                person => $nom->id,
                object_type => 'SpecialEvents',
                object_id => $c->stash->{event}->id,
                action => 'create'
            }
        );
        $c->stash->{confirm}->random_code;

        $c->forward('send_confirmation');
    };
    if ($@) {
        $c->log->error("Failed to create special event: $@");
        $c->stash->{message} = $@;
    }
    else {
        $c->stash->{template} = 'manage/specialevent/created.tt';
    }
}

# TODO: Convert this to use a Template::Toolkit template, rather than inline
# text.
sub send_confirmation :Private {
    my ($self, $c) = @_;

    my $conf = $c->stash->{confirm};

    my $body = '
Hi ' . $c->stash->{confirm}->person->name . ',
Someone, hopefully you, nominated the following special event at
http://eventbot.dryft.net/. You need to confirm this event by clicking the
following link. If you did not request this event, please ignore this email.

Event details:
Date: ' . $c->stash->{event}->date->dmy . '
Venue: ' . $c->stash->{event}->pub->name . '

To confirm click here:
http://eventbot.dryft.net/manage/confirm/' . $conf->code . '

Thanks,
EventBot
';
    my $email = MIME::Lite->new(
        From => 'eventbot@dryft.net',
        To => $conf->person->email,
        Bcc => 'dryfter@gmail.com',
        Subject => 'Event nomination confirmation',
        Data => $body
    );
    $c->log->info('Sending email to ' . $conf->person->email);
    $email->send;
}


sub specialevent_id :Chained('specialevent') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->stash->{event} = $c->model('DB::SpecialEvents')->search(
        { id => $id, confirmed => 1 }
    )->next;
}

sub specialevent_details :Chained('specialevent_id') PathPart('') Args(0) {
    my ($self, $c) = @_;

}

sub specialevent_home :Chained('specialevent') PathPart('') Args(0) {
    my ($self, $c) = @_;
}

1;
