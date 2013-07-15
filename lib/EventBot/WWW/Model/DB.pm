# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Model::DB;
use 5.16.0;
use warnings;
use parent 'Catalyst::Model::DBIC::Schema';
require EventBot::WWW; # TODO: Remove this almost-circular dependency..
# (We use to get at the config object, which we can access in better ways)

__PACKAGE__->config(
    schema_class => 'EventBot::Schema',
    connect_info => [
        EventBot::WWW->config->{database}{dsn},
        EventBot::WWW->config->{database}{username},
        EventBot::WWW->config->{database}{password},
        {
            AutoCommit => 1,
            pg_enable_utf8 => 1,
            pg_server_prepare => 1
        }
    ],
 
);

=head1 NAME

EventBot::WWW::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<EventBot::WWW>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<EventBot::Schema>

=head1 AUTHOR

Toby Corkindale, tjc@cpan.org

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
