package EventBot::WWW::C::Election;

use strict;
use warnings;
use base 'Catalyst::Controller';
use feature ':5.10';

=head1 NAME

EventBot::WWW::C::Election

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
        when ('current') {
            $c->stash->{election} = $c->model('DB::Elections')->search(
                { enabled => 1 },
                { order_by => 'id DESC', rows => 1 }
            )->next;
        }
        when ('last') {
            $c->stash->{election} = $c->model('DB::Elections')->search(
                { },
                { order_by => 'id DESC', rows => 1 }
            )->next;
        }
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
