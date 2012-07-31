# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::AdminLogs;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('admin_logs');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_auto_increment => 1 },
    admin => { data_type => 'INTEGER' },
    action => { data_type => 'TEXT' },
    stamp => { data_type => 'TIMESTAMP',
               default_value => \'CURRENT_TIMESTAMP'
             },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(admin => 'EventBot::Schema::Result::Admins');

1;
__DATA__

CREATE TABLE admin_logs (
    id SERIAL PRIMARY KEY,
    admin INTEGER NOT NULL REFERENCES admins (id),
    action TEXT NOT NULL,
    stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

