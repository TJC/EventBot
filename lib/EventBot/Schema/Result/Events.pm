# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::Events;
use strict;
use warnings;
use base 'DBIx::Class';
use Digest::MD5 qw(md5_hex);
use DateTime::Format::Pg;

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

__PACKAGE__->has_many(
    attendees => 'EventBot::Schema::Result::Attendees',
    'event'
);

# Ugh, I didn't use auto-inflating date columns in this class, so now I'm
# resorting to this as I'm not sure adding them now won't break something..
sub date_obj {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime($self->startdate);
}

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
        warn "In add_people, adding $name=$status\n";
        if (length($name) > 60) {
            warn "Skipping person as detected name is too long to be correct\n";
            next;
        }

        # We have made email a unique, not null field, but we don't have
        # that data right now, right here. Instead, fake it up with an MD5 of
        # their name, and work this out later..
        my $md5 = md5_hex($name);

        # Attempt to find their real user first:
        my $person = $self->result_source->schema->resultset('People')
            ->search(
                {
                    name => $name,
                    email => { '<>' => $md5 },
                },
                { rows => 1 },
            )->single;

        if (not $person) {
            $person = $self->result_source->schema->resultset('People')
                ->find_or_create(
                    {
                        name => $name,
                        email => $md5
                    }
                );
        }

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
    # Ditch trailing periods:
    $name =~ s/\s*\.+\s*//;
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
