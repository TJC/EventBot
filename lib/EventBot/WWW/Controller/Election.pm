# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::Election;

use strict;
use warnings;
use base 'Catalyst::Controller';
use feature ':5.10';

=head1 NAME

EventBot::WWW::Controller::Election

=head1 DESCRIPTION

Catalyst Controller.

Displays info about votes and election results.

=head1 METHODS

=cut

=head2 election

Start of chain..

Takes parameter of which election, which can also be "current" or "last".

=cut

sub election :Chained PathPart('election') CaptureArgs(1) {
    my ($self, $c, $eid) = @_;
    given ($eid) {
        when (/^\d+$/) {
            $c->stash->{election} = $c->model('DB::Elections')->find($eid);
        }
        when ('latest') {
            $c->stash->{election} = $c->model('DB::Elections')->latest;
        }
        when ('current') {
            $c->stash->{election} = $c->model('DB::Elections')->current;
        }
        when ('last') {
            $c->stash->{election} = $c->model('DB::Elections')->previous;
        }
    }

    if (not $c->stash->{election}) {
        $c->response->status(404);
        $c->response->body('Election not found');
        return 0;
    }
}

=head2 result

Show the results of the election.

=cut

sub result :Chained('election') PathPart('result') Args(0) {
    my ($self, $c) = @_;
   
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
