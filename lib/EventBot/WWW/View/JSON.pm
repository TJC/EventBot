package EventBot::WWW::View::JSON;
use strict;
use warnings;
use parent qw(Catalyst::View);
use JSON::XS;

=head1 NAME

EventBot::WWW::View::JSON

=head1 DESCRIPTION

JSON view for EventBot.

=head1 AUTHOR

Toby Corkindale

=head1 METHODS

=cut

=head2 process

Convert $c->stash->{response} into JSON and return that as document body.

=cut

sub process {
    my ($self, $c) = @_;

    $c->response->body(
        encode_json($c->stash->{response})
    );

    $c->response->content_type('text/json');
}

1;
