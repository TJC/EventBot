package EventBot::Schema::Pubs;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('pubs');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    name => { data_type => 'VARCHAR', size => 64, is_nullable => 0 },
    street_address => { data_type => 'VARCHAR', size => 80, is_nullable => 1 },
    region => { data_type => 'VARCHAR', size => 64, is_nullable => 1 },
    info_uri => { data_type => 'VARCHAR', size => 128, is_nullable => 1 },
    endorsed => {
        data_type => 'BOOLEAN',
        is_nullable => 0,
        default_value => 0
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw(name region)]);
__PACKAGE__->has_many(endorsements => 'EventBot::Schema::Endorsements', 'pub');
__PACKAGE__->many_to_many(
    nominees => 'endorsements', 'person'
);

1;
