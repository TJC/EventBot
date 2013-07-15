# vim: sw=4 sts=4 et tw=75 wm=5
package Test::EventBot;
use strict;
use warnings;
use FindBin;
use File::Temp qw(:seekable);
use Config::General qw(SaveConfig);
use Try::Tiny;
use EventBot::Schema;
use Test::More;
use Test::WWW::Mechanize::Catalyst;

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

    $config_file = File::Temp->new(SUFFIX => '.conf');
    $ENV{CATALYST_CONFIG} = $ENV{EVENTBOT_CONFIG} = $config_file->filename;

    $ENV{EVENTBOT_TEST} = 1;

    # Setup a config file:
    my %test_config = Config::General->new("$FindBin::Bin/../eventbot.conf")->getall;
    $test_config{database}{dsn} =
        $test_config{"Model::DB"}{connect_info}{dsn} =
            "dbi:Pg:dbname=$EventBot_DB";

    $test_config{"Model::DB"}{connect_info}{username} =
        $test_config{database}{username} = "$ENV{USER}";

    $test_config{"Model::DB"}{connect_info}{password} =
        $test_config{database}{password} = "";

    $test_config{list_addr} = 'sluts@example.com';
    $test_config{from_addr} = 'eventbot@example.com';

    SaveConfig($config_file->filename, \%test_config);
}

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
        try {
            $schema->resultset('Pubs')->search->next;
        }
        catch {
           if ($_ =~ /(no such table|does not exist)/i) {
               note("Deploying database $EventBot_DB");
               $schema->deploy;
            } else {
                die $_;
            }
        };
    }

    return $schema;
}

=head2 config_file

Returns the filename for the config file for testing.

=cut

sub config_file {
    return $config_file->filename;
}

# Ensure schema exists and test config written out before starting app
sub mech {
    schema();
    return Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'EventBot::WWW');
}

=head2 END

Clean up the DB we created at the start..

=cut

sub END {
     # The test harnesses tend to hold the DB connection open until after END
     # is called, so we queue the delete for a moment later:
     print STDERR "Dropping Test DB " . $EventBot_DB . "\n";
     open(my $fh, "| at 'now + 2 minutes'");
     print $fh "dropdb $EventBot_DB\n";
     close $fh;
}

1;
