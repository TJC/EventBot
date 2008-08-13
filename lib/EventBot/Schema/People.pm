package EventBot::Schema::People;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('people');
__PACKAGE__->add_columns(qw(
    id name email
));
__PACKAGE__->set_primary_key('id');


__PACKAGE__->has_many(attends => 'EventBot::Schema::Attendees', 'person');
__PACKAGE__->many_to_many(events => 'attends', 'event');


1;
