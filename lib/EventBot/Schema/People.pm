package EventBot::Schema::People;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('people');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    name => { data_type => 'VARCHAR', size => 64, is_nullable => 0 },
    email => { data_type => 'VARCHAR', size => 128, is_nullable => 0 },
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint([qw(email)]);

__PACKAGE__->has_many(attends => 'EventBot::Schema::Attendees', 'person');
__PACKAGE__->many_to_many(events => 'attends', 'event');

__PACKAGE__->has_many(
    votes => 'EventBot::Schema::Votes', 'person'
);
__PACKAGE__->has_many(
    nominations => 'EventBot::Schema::Endorsements', 'person'
);
__PACKAGE__->many_to_many(endorsed => 'nominations', 'pub');

# Return a version of their email address that is slightly redacted to
# prevent email harvesting.
sub email_redacted {
    my $self = shift;
    my $email = $self->email;
    return '***' unless length($email) > 3;
    my $len = int(length($email) / 3.0);
    substr($email, $len, $len, '*'x$len);
    return $email;
}

1;
