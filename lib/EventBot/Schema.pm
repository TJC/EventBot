package EventBot::Schema;
use Moose;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_classes;

before 'deploy' => sub {
    my $schema = shift;
    # Prevent all the NOTICE things during deployment:
    $schema->storage->dbh->do('SET client_min_messages = warning');
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
