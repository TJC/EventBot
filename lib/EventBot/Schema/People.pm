package EventBot::Schema::People;
use strict;
use warnings;

__PACKAGE__->has_many(attends => 'EventBot::Schema::Attendees', 'person');
__PACKAGE__->many_to_many(events => 'attends', 'event');


1;
