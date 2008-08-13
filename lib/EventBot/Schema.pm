package EventBot::Schema;
use warnings;
use strict;
use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes(qw(
    Attendees
    Events
    People
    Venues
));

1;
