package Fixture::Base;
use strict;
use warnings;
use Test::EventBot;

=head1 NAME

Fixture::Base

=head1 SYNOPSIS

  use parent 'Fixture::Base';

=head1 METHODS

=cut

=head2 schema

Returns the DBIx::Class schema.

=cut

sub schema {
    return Test::EventBot->schema;
}

1;
