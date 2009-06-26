package EventBot::WWW::C::Manage::Pub;
use strict;
use warnings;
use parent 'Catalyst::Controller';

# This module should contain methods to edit, nominate, endorse pubs.
# Note that the *other* Pub.pm already contains methods to list and view pub
# details, so I'm just going to chain off there for the extra methods, I
# think..

sub endorse : Chained('/pub/pub_name') PathPart Args(0) {
    my ($self, $c) = @_;

}

sub edit : Chained('/pub/pub_name') PathPart Args(0) {
    my ($self, $c) = @_;

}

1;
