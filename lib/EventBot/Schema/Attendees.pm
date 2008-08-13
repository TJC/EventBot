package EventBot::Schema::Attendees;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('attendees');
__PACKAGE__->add_columns(qw(
    event person status comment
));
__PACKAGE__->set_primary_key(qw(event person));


__PACKAGE__->belongs_to(event => 'EventBot::Schema::Events');
__PACKAGE__->belongs_to(person => 'EventBot::Schema::People');


1;
