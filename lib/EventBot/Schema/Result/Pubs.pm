# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Result::Pubs;
use strict;
use warnings;
use parent 'DBIx::Class';
use Carp qw(carp croak);
use URI::Escape qw(uri_escape);
use overload
    '""' => sub {
        my $self = shift;
        sprintf('%s (%s)', $self->name, $self->region);
    },
    '~~' => sub {
        my ($left, $right) = @_;
        carp "Smart-matching Pub object probably won't work!";
        warn "Left = $left, right = $right";
        return($left eq $right);
    },
    fallback => 1;

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('pubs');
__PACKAGE__->add_columns(
    id => { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
    name => { data_type => 'VARCHAR', size => 64, is_nullable => 0 },
    street_address => { data_type => 'VARCHAR', size => 80, is_nullable => 1 },
    region => { data_type => 'VARCHAR', size => 64, is_nullable => 1 },
    info_uri => { data_type => 'VARCHAR', size => 128, is_nullable => 1 },
    endorsed => {
        data_type => 'BOOLEAN',
        is_nullable => 0,
        default_value => 0
    },
    lat => { data_type => 'REAL', is_nullable => 1 },
    lng => { data_type => 'REAL', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw(name region)]);
__PACKAGE__->has_many(
    endorsements => 'EventBot::Schema::Result::Endorsements', 'pub'
);
__PACKAGE__->many_to_many(
    nominees => 'endorsements', 'person'
);

sub name_escaped {
    my $self = shift;
    return uri_escape($self->name);
}

sub region_escaped {
    my $self = shift;
    return uri_escape($self->region);
}

sub url_to_self {
    my $self = shift;
    return sprintf('/pub/%s/%s', $self->region_escaped, $self->name_escaped);
}

1;
