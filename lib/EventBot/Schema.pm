package EventBot::Schema;
use warnings;
use strict;
use base 'DBIx::Class::Schema::Loader';

__PACKAGE__->loader_options(
    relationships => 1
);

1;
