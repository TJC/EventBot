# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::PubStatus;
use strict;
use warnings;
use parent 'DBIx::Class';
use overload
    '""' => sub {
        return $_[0]->name
    },
    fallback => 1;

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('pub_status');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_auto_increment => 1 },
    name => { data_type => 'VARCHAR', size => 16 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many(
    pubs => 'EventBot::Schema::Result::Pubs', 'status'
);

1;
