package EventBot::Schema::Events;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('events');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    startdate => {
        data_type => 'DATE',
        is_nullable => 1
    },
    starttime => {
        data_type => 'VARCHAR',
        size => 64,
        is_nullable => 1,
    },
    place => {
        data_type => 'VARCHAR',
        size => 128,
        is_nullable => 1
    },
    url => {
        data_type => 'VARCHAR',
        size => 128,
        is_nullable => 1
    },
    comments => {
        data_type => 'TEXT',
        is_nullable => 1
    },
    lat_long => {
        data_type => 'POINT',
        is_nullable => 1
    },
);
__PACKAGE__->set_primary_key('id');

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
