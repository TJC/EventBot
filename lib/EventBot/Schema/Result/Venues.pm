# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::Venues;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('venues');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    name => {
        data_type => 'VARCHAR',
        size => 128,
        is_nullable => 1
    },
    url => {
        data_type => 'VARCHAR',
        size => 128,
        is_nullable => 1
    },
    comments => {
        data_type => 'TEXT',
        is_nullable => 1
    },
    lat_long => { data_type => 'POINT', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');


1;
