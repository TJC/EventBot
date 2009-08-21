# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Attendees;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('attendees');
__PACKAGE__->add_columns(
    event => {
        data_type => 'INTEGER',
        is_nullable => 0,
    },
    person => {
        data_type => 'INTEGER',
        is_nullable => 0,
    },
    status => {
        data_type => 'VARCHAR',
        size => 5,
        is_nullable => 1,
    },
    comment => {
        data_type => 'VARCHAR',
        size => 80,
        is_nullable => 1,
    },
);
__PACKAGE__->set_primary_key(qw(event person));


__PACKAGE__->belongs_to(event => 'EventBot::Schema::Events');
__PACKAGE__->belongs_to(person => 'EventBot::Schema::People');


1;
