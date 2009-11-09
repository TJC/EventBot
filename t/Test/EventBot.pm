# vim: sw=4 sts=4 et tw=75 wm=5
package Test::EventBot;
use strict;
use warnings;
use FindBin;
use File::Temp qw(:seekable);
use Config::General qw(SaveConfig);

=head1 NAME

Test::EventBot

=head1 DESCRIPTION

Used to setup a temporary database for testing Eventbot, and use a temporary
configuration file.

=head1 METHODS

=cut

my $config_file;
my $EventBot_DB;
BEGIN {
    $EventBot_DB = "test_eventbot_$$";
    print STDERR "Creating database $EventBot_DB\n";
    system('createdb', '--encoding=utf8', $EventBot_DB);

    $config_file = File::Temp->new(SUFFIX => '.cfg');
    $ENV{EVENTBOT_CONFIG} = $config_file->filename;

    $ENV{EVENTBOT_TEST} = 1;

    print "\nFindBin = $FindBin::Bin\n\n";
}
use EventBot::Schema;

# Setup a config file:
my %test_config = Config::General->new("$FindBin::Bin/../eventbot.cfg")->getall;
$test_config{database}->{dsn} = "dbi:Pg:dbname=$EventBot_DB";
$test_config{database}->{username} = '';
$test_config{database}->{password} = '';
$test_config{list_addr} = 'sluts@example.com';
$test_config{from_addr} = 'eventbot@example.com';
SaveConfig($config_file->filename, \%test_config);

=head2 schema

Returns a DBIx::Class::Schema for the DB.

=cut

our $schema;
sub schema {
    my $class = shift;
    if (not defined $schema) {
        $schema = EventBot::Schema->connect(
            "dbi:Pg:dbname=$EventBot_DB"
        );
        # Verify we're deployed:
        eval {
            $schema->resultset('Pubs')->search->next;
        };
        if ($@) {
           if ($@ =~ /(no such table|does not exist)/i) {
               warn "Deploying database $EventBot_DB..\n"
                   unless $ENV{HARNESS_ACTIVE};
               $schema->deploy;
            } else {
                die $@;
            }
        }
    }

    return $schema;
}

=head2 config_file

Returns the filename for the config file for testing.

=cut

sub config_file {
    return $config_file->filename;
}

=head2 END

Clean up the DB we created at the start..

=cut

sub END {
     # The test harnesses tend to hold the DB connection open until after END
     # is called, so we queue the delete for a moment later:
     print STDERR "Dropping Test DB " . $EventBot_DB . "\n";
     open(my $fh, "| at 'now + 1 minutes'");
     print $fh "dropdb $EventBot_DB\n";
     close $fh;
}

1;
