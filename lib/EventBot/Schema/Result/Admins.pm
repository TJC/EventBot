# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::Admins;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('admins');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_auto_increment => 1 },
    name => { data_type => 'VARCHAR', size => 64 },
    password => { data_type => 'VARCHAR', size => 64 },
    active => { data_type => 'BOOLEAN', default_value => 0 },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint([qw(name)]);

__PACKAGE__->has_many(logs => 'EventBot::Schema::Result::AdminLogs', 'admin');

1;
__DATA__

CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT false
);

