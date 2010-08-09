# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::Elections;
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
    votes => 'EventBot::Schema::Result::Votes', 'election'
);
__PACKAGE__->might_have(
    'winner' => 'EventBot::Schema::Result::Pubs',
    { 'foreign.id' => 'self.winner' }
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

=head2 vote

Usage:

  $user = $schema->resultset('People')->find(...);
  $election->vote('A', $user);

=cut

sub vote {
    my ($self, $votes, $person) = @_;
    die("Missing votes") unless ($votes and @$votes);
    die("Missing person") unless $person;

    $self->result_source->schema->txn_do(sub {
        # Delete any previous votes:
        $self->search_related('votes',
            {
                person => $person->id
            }
        )->delete;
        my $rank = 1;
        for my $vote (@$votes) {

            die("Invalid vote: $vote") unless $vote =~ /^[A-Z]$/;

            # Need to convert $pub into the correct ID from the candidates..
            my $vote_num = ord($vote) - ord('A');
            my @cand_list = split(':', $self->candidate_list);
            my $candidate_id = $cand_list[$vote_num];
            my $pub = $self->result_source->schema->resultset('Pubs')
                ->find($candidate_id);

            die("Invalid vote, pub $vote ($candidate_id) not found")
                unless $pub;

            $self->add_to_votes(
                {
                    person => $person,
                    rank => $rank++,
                    pub => $pub
                }
            );

        }
    });
}

=head2 conclude

Concludes the election, and tallies up the results.

=cut

sub conclude {
    my $self = shift;

    my $rs = $self->search_related('votes', undef,
        {
            select => [ 'pub', { sum => '(5-rank)*2' } ],
            as => ['pub', 'pub_score'],
            group_by => ['pub'],
        }
    );

    # sort in descending order: (because dbix wasn't letting me sort)
    my @results = sort {
        $b->get_column('pub_score') <=> $a->get_column('pub_score')
    } $rs->all;

    $self->winner($results[0]->pub);
    $self->enabled(0);
    $self->update;

    return @results;
}

1;
