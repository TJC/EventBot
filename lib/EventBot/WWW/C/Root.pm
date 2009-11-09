# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::C::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

EventBot::WWW::C::Root - Root Controller for EventBot::WWW

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 default

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'frontpage.tt';
}

sub fourohfour : Private {
    my ($self, $c) = @_;
    $c->stash->{template} = '404.tt';
    $c->response->status(404);
    $c->stash->{current_view} = 'TT'; # Even if you hit the API..
}

sub default : Private {
    my ($self, $c) = @_;
    $c->detach('fourohfour');
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head2 about

display about box..

=cut

sub about :Path('/about') {
    my ($self, $c) = @_;
}

=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
