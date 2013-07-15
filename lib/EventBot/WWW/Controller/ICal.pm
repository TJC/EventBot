# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::ICal;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use DateTime;
use Data::ICal;
use Data::ICal::DateTime;
use Data::ICal::Entry::Event;

=head1 NAME

EventBot::WWW::Controller::ICal

=head1 DESCRIPTION

Catalyst Controller for iCalendar feeds.

=head1 METHODS

=cut


=head2 index 

Upcoming events by RSS

=cut

sub index :Private {
    my ( $self, $c ) = @_;

    my $recently = DateTime->now;
    $recently->add(days => -14);

    my $events = $c->model('DB::Events')->search(
        {
            startdate => { '>=' => $recently },
        },
        { order_by => 'startdate' }
    );

    my $specEvents = $c->model('DB::SpecialEvents')->search(
        {
            date => { '>=' => $recently },
            confirmed => 1
        },
        { order_by => 'date' }
    );


    my $cal = Data::ICal->new;

    while (my $event = $events->next) {
        my $item = Data::ICal::Entry::Event->new;
        $item->add_properties(
            summary => "Sluts meet",
            description => $event->place,
            location => $event->place,
            url => $event->url,
        );
        my $start = $event->date_obj;
        $start->set(hour => 19);
        $item->start($start);
        $item->duration(DateTime::Duration->new(hours => 3));

        $cal->add_entry($item);
    }

    while (my $event = $specEvents->next) {
        my $item = Data::ICal::Entry::Event->new;
        $item->add_properties(
            summary => sprintf('%s\'s %s',
                           $event->person->name, $event->comment
                       ),
            description => $event->comment . " at " . $event->pub->name,
            location => sprintf('%s (%s)',
                            $event->pub->street_address,
                            $event->pub->region
                        ),
            url => $event->pub->info_uri,
        );
        my $start = $event->date;
        $start->set(hour => 19);
        $item->start($start);
        $item->duration(DateTime::Duration->new(hours => 3));

        $cal->add_entry($item);
    }

    $c->response->body($cal->as_string);
    $c->response->content_type('text/calendar; charset=utf-8');
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

Undecided

=cut

1;
