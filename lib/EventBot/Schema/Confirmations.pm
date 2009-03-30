package EventBot::Schema::Confirmations;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('confirmations');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    # The person who needs to confirm action:
    person => { data_type => 'INTEGER', is_nullable => 0 },
    # The type (ie. resultset) of the related object:
    object_type => { data_type => 'VARCHAR', size => 64, is_nullable => 0 },
    # The other object's ID:
    object_id => { data_type => 'INTEGER', is_nullable => 0 },
    # The magic password they need to confirm with:
    code => { data_type => 'VARCHAR', size => 64, is_nullable => 1 },
    # Action to take on the foreign object:
    action => { data_type => 'TEXT', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(person => 'EventBot::Schema::People');

=head2 object

Returns the object this confirmation refers to..

=cut

sub object {
    my $self = shift;
    return $self->result_source->schema
         ->resultset($self->object_type)
         ->find($self->object_id);
}

=head2 random_code

Sets a random confirmation code.

=cut

sub random_code {
    my $self = shift;
    my @char_set = (qw(
        A C D E F G H J K L M N P Q R S T V W X Y Z 3 4 5 6 7 9
    ));
    my @token = map { $char_set[rand @char_set] } (1..10);
    $self->code(join('', @token));
    $self->update;
    return $self->code;
}

1;
