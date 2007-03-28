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

    while (my ($line, $statid) = each %people) {
        my $status = $statusmap{$statid};
        my ($name, $comment) = split_name_comment($line);
        warn "In add_people, adding $name/$comment=$status\n";
        my $person =
        $self->result_source->schema->resultset('People')
            ->find_or_create( { name => $name }
        );
        my $a = $self->result_source->schema->resultset('Attendees')
            ->find_or_create({
                person => $person->id,
                event => $self->id
            });
        $a->status($status);
        $a->comment($comment) unless not $comment;
        $a->update;
    }
}

sub split_name_comment {
    my $name = shift;
    if ($name =~ /^
            ([[:print:]]+?)
            \s*
            \(([[:print:]]+)\)
            \s*$
            /x) {
        return($1, $2);
    }
    return $name;
}


1;
