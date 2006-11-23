package EventBot::Schema::Events;
use strict;
use warnings;

__PACKAGE__->has_many(attendees => 'EventBot::Schema::Attendees', 'event');

our %statusmap = (
    '+' => 'Yes',
    '-' => 'No',
    '?' => 'Maybe',
);

sub add_people {
    my ($self, %people) = @_;

    foreach my $name (keys %people) {
        my $person =
        $self->result_source->schema->resultset('People')
            ->find_or_create( { name => $name }
        );
        my $a = $self->result_source->schema->resultset('Attendees')
            ->find_or_create({
                person => $person->id,
                event => $self->id
            });
        $a->status($statusmap{$people{$name}});
    }
}

1;
