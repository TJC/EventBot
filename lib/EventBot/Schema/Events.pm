package EventBot::Schema::Events;
use strict;
use warnings;

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
        $self->result_source->schema->resultset('Attendees')
            ->create({
                person => $person->id,
                event => $self->id,
                status => $statusmap{$people{$name}},
            });
    }
}

1;
