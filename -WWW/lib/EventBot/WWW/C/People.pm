package EventBot::WWW::C::People;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::C::People - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 top 

Show top attendees

=cut

sub top :Local {
    my ( $self, $c ) = @_;

    my $query = {
            select => [
                'person',
                { count => 'person' }
            ],
            as => [qw/person count/],
            group_by => ['person'],
            order_by => 'count DESC',
            rows => 10,
    };

    $c->stash->{attendees} = $c->model('Attendees')->search(
        { 'status' => 'Yes', }, $query
    );
    $c->stash->{absentees} = $c->model('Attendees')->search(
        { 'status' => 'No', }, $query
    );
    $c->stash->{unknown} = $c->model('Attendees')->search(
        { 'status' => 'Maybe', }, $query
    );
}

=head2 view

View events a person has attended.

=cut

sub view :Local {
    my ($self, $c, $id) = @_;
    if ($id =~ /^(\d+)$/) {
        $c->stash->{person} = $c->model('DB::People')->find($1);
    }
    elsif ($id =~ /([-_\w\d\'\" ]+)/) {
        $c->stash->{person} = $c->model('DB::People')->search(
            { name => $1 }
        )->first;
    }
    if (not $c->stash->{person}) {
        $c->log->error('Person not found');
        $c->stash->{message} = 'Person not found';
        return;
    }
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

Undecided.

=cut

1;
