package EventBot::Form::Pub;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types qw(NoSpaces WordChars NotAllDigits);
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Pubs' );

has_field 'name' => (
    label => 'Name',
    type => 'Text',
    size => 20,
    required => 1,
);

sub validate_name {
    my ($self, $field) = @_;
    $field->add_error('Not allowed to edit meta-pubs!')
        if $field->value =~ /None of the above/i;
}

has_field 'street_address' => (
    label => 'Street address',
    type => 'Text',
    size => 60,
    required => 1,
);

has_field 'region' => (
    label => 'Region',
    type => 'Text',
    size => 20,
    required => 1,
);

has_field 'info_uri' => (
    label => 'Their URL',
    type => 'Text',
    size => 80,
    required => 0,
);

has_field 'submit' => (
    type => 'Submit',
    label => 'Save',
    order => 999,
);

after 'validate' => sub {
    my $self = shift;
    # Check that the name+region is unique:
    if ($self->schema->resultset('Pubs')->search(
            {
                name => $self->field('name')->value,
                region => $self->field('region')->value,
                id => { '!=' => $self->item->id },
            }
        )->count
    ) {
        $self->field('name')->add_error(
            'There already appears to be a pub with this name in this region.'
        );
    }
    1;       
};

__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;
1;
