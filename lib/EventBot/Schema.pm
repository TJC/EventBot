# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema;
use Moose;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

before 'deploy' => sub {
    my $schema = shift;
    # Prevent all the NOTICE things during deployment:
    $schema->storage->dbh->do('SET client_min_messages = warning');
};

after 'deploy' => sub {
    my $schema = shift;
    my $rs = $schema->resultset('PubStatus');
    for my $status (qw(Open Closed)) {
        $rs->create({name => $status});
    }
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
