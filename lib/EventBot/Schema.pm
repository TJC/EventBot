# vim: sw=4 sts=4 et tw=75 wm=5
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
