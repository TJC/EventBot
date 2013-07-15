package Fixture::Pub;
use 5.16.0;
use warnings;
use parent qw(Fixture::Base);

our $pubcount = 0;

=head1 NAME

Fixture::Pub

=head1 SYNOPSIS

  use Test::EventBot;
  use Fixture::Pub;
  my $pub = Fixture::Pub->new;

=head1 METHODS

=cut

=head2 new

Constructor.

=cut

sub new {
    my ($class, %args) = @_;

    my $unique = $$ + $pubcount++;
    my $name = "The Old Red $unique";
    my $address = "$unique Old Street";

    my $pub = $class->schema->resultset('Pubs')->create(
        {
            name => "The Old Red $unique",
            street_address => "$unique Old Street",
            region => "Testing",
            info_uri => "http://example.com/$unique",
            status => { name => 'Open' },
        }
    );

    return $pub;
}

1;
