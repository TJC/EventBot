# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Elections;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(ResultSetManager InflateColumn::DateTime Core));
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
    votes => 'EventBot::Schema::Votes', 'election'
);
__PACKAGE__->might_have(
    'winner' => 'EventBot::Schema::Pubs',
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

=head2 commence

Start a new election!

This determines the candidates, and will return the election object.

=cut

sub commence :ResultSet {
    my ($self, $args) = @_;
    my $max_id_query = $self->result_source->schema->storage->dbh->prepare(
        'SELECT MAX(id) FROM pubs'
    );
    $max_id_query->execute;
    my ($max_id) = $max_id_query->fetchrow_array;
    warn "Maximum ID of pubs: $max_id\n";
    die("Not enough pubs in database") unless $max_id >= 5;

    my $election = $self->create(
        {
            enabled => 1
        }
    );

    my $none_of_the_above = $self->result_source->schema->resultset('Pubs')
        ->find_or_create(
            {
                name => 'None of the Above',
                region => 'Anywhere',
                street_address => 'To be specified manually'
            }
        );

    my @pubs;
    my %seen_pubs;
    # Avoid picking birthday pubs in the random pub selection..
    if ($args->{extra}) {
        %seen_pubs = map { $_->id => 1 } @{$args->{extra}};
    }
    while (@pubs < 4) {
        my $pub = $self->_get_random_pub($max_id);
        # next if $pub ~~ @pubs;
        # Smart-matching objects deferred until 5.10.1
        next if $seen_pubs{$pub->id};
        $seen_pubs{$pub->id} = 1;
        next unless $pub->endorsed;
        push(@pubs, $pub);
    }

    # Add extra birthday pubs:
    if ($args->{extra}) {
        push(@pubs, @{$args->{extra}});
    }

    # Add the none-of-the-above option:
    push(@pubs, $none_of_the_above);
    $election->candidates(@pubs);

    return $election;
}

=head2 _get_random_pub

This finds us a random pub out of the whole set, given the maximum ID.

Note that it's not very efficient.. We'd be better off doing and initial
count() of available pubs, then:

SELECT id FROM pubs
WHERE endorsed IS TRUE
OFFSET $random
LIMIT 1

But eh, it works anyway..

=cut

sub _get_random_pub :ResultSet {
    my ($self, $max) = @_;

    my $pub;
    do {
        my $id = int(rand($max+1));
        $pub = $self->result_source->schema->resultset('Pubs')->find($id);
    } while (not $pub);
    return $pub;
}

=head2 latest

Returns the latest election.

=cut

sub latest :ResultSet {
    my ($self) = @_;
    return $self->search(
        undef,
        {
            order_by => 'id DESC',
            rows => 1,
        }
    )->next;
}

=head2 previous

Returns the previous election to the latest, ie. 2nd most recent.

=cut

sub previous :ResultSet {
    my ($self) = @_;
    return $self->search(
        undef,
        {
            order_by => 'id DESC',
            rows => 1,
            offset => 1,
        }
    )->next;
}

=head2 current

Returns the current election, ie. latest which is enabled.

=cut

sub current :ResultSet {
    my ($self) = @_;
    return $self->search(
        { enabled => 1 },
        {
            order_by => 'id DESC',
            rows => 1,
        }
    )->next;
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
        $a->get_column('pub_score') <= $b->get_column('pub_score')
    } $rs->all;

    $self->winner($results[0]->pub);
    $self->enabled(0);
    $self->update;

    return @results;
}

1;
