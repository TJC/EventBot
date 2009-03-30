package EventBot::Schema::SpecialEvents;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(InflateColumn::DateTime Core));
__PACKAGE__->table('special_events');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    # Who nominated this special event:
    person => { data_type => 'INTEGER', is_nullable => 0 },
    # Which venue does it apply to?
    pub => { data_type => 'INTEGER', is_nullable => 0 },
    # When is it?
    date => { data_type => 'DATE', is_nullable => 0 },
    confirmed => {
        data_type => 'BOOLEAN', is_nullable => 0, default_value => 0
    },
    comment => { data_type => 'VARCHAR', size => 256, is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(person => 'EventBot::Schema::People');
__PACKAGE__->belongs_to(pub => 'EventBot::Schema::Pubs');

1;
