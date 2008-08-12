package EventBot::WWW::M::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'EventBot::Schema',
    connect_info => [
        EventBot::WWW->config->{db}{dsn},
        EventBot::WWW->config->{db}{username},
        EventBot::WWW->config->{db}{password},
        {
            AutoCommit => 1,
            pg_enable_utf8 => 1,
            pg_server_prepare => 1
        }
    ],
 
);

=head1 NAME

EventBot::WWW::M::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<EventBot::WWW>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<EventBot::Schema>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
