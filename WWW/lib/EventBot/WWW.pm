package EventBot::WWW;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a YAML file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use Catalyst qw/ConfigLoader Static::Simple/;

our $VERSION = '0.10';

# Configure the application. 
#
# Note that settings in EventBot::WWW.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'EventBot::WWW' );

# Start the application
__PACKAGE__->setup;


=head1 NAME

EventBot::WWW - Catalyst based application

=head1 SYNOPSIS

    script/eventbot_www_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<EventBot::WWW::C::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
