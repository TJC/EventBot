package EventBot::Schema::Elections;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(InflateColumn::DateTime Core));
__PACKAGE__->table('elections');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    created => {
        data_type => 'TIMESTAMP',
        is_nullable => 0, 
        default_value => \'CURRENT_TIMESTAMP'
    },
    enabled => {
        data_type => 'BOOLEAN',
        is_nullable => 0,
        default_value => 0
    },
    # Terribly denormalised, but eh, should be good for now..
    candidate_list => {
        data_type => 'VARCHAR',
        size => 32,
        is_nullable => 1,
    },
    winner => {
        data_type => 'INTEGER',
        is_nullable => 1
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(
    votes => 'EventBot::Schema::Votes'
);

sub candidates {
    my ($self, @pubs) = @_;

    if (scalar(@pubs) > 0) {
        $self->candidate_list(
            join(':', map { $_->id } @pubs)
        );
        $self->update;
        return @pubs;
    }

    return map {
        $self->result_source->schema->resultset('Pubs')->find($_)
    } split(':', $self->candidate_list);
}

1;
