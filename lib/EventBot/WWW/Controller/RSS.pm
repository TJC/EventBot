# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::RSS;

use strict;
use warnings;
use base 'Catalyst::Controller';
use XML::RSS;

=head1 NAME

EventBot::WWW::Controller::RSS - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller for RSS feeds.

=head1 METHODS

=cut


=head2 upcoming 

Upcoming events by RSS

=cut

sub upcoming :Local {
    my ( $self, $c ) = @_;

    my $rss = new XML::RSS;
    $rss->channel(
        title => 'EventBot',
        'link' => 'http://eventbot.dryft.net/',
        description => 'Upcoming EventBot events',
        syn => {
            updatePeriod => 'daily',
            updateFrequency => '5',
            updateBase => '2006-01-01T00:00'
        }
    );

    # Get events:
    $c->forward($c->controller('Event'), 'list');

    # Foreach upcoming event, do:
    foreach my $event ($c->stash->{events}->all) {
        $rss->add_item(
            title => $event->startdate . ':' . $event->place,
            'link' => 'http://eventbot.dryft.net/event/view/' . $event->id
        );
    }

    $c->response->body($rss->as_string);
    # TODO: Include character set!
    $c->response->content_type('application/rss+xml');
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

Undecided

=cut

1;
