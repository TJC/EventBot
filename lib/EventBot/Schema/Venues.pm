package EventBot::Schema::Venues;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('venues');
__PACKAGE__->add_columns(qw(
    id name url comments lat_long
));
__PACKAGE__->set_primary_key('id');


1;
