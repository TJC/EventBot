# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::ResultSet::Elections;
use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

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

1;
