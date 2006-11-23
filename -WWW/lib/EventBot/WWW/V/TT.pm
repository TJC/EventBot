package EventBot::WWW::V::TT;

use strict;
use base 'Catalyst::View::TT';
use Template::Stash::XS;

__PACKAGE__->config(TEMPLATE_EXTENSION => '.tt');

__PACKAGE__->config(
    STASH => Template::Stash::XS->new,
);


=head1 NAME

EventBot::WWW::V::TT - TT View for EventBot::WWW

=head1 DESCRIPTION

TT View for EventBot::WWW. 

=head1 AUTHOR

=head1 SEE ALSO

L<EventBot::WWW>

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
