package EventBot::MailParser;
use strict;
use warnings;
use parent 'Class::Accessor';
use Email::Simple;
use Email::MIME;
use EventBot::MailParser::Votes;
use EventBot::MailParser::Events;

__PACKAGE__->mk_accessors(qw(commands from));

our @PARSERS = ('EventBot::MailParser::Votes', 'EventBot::MailParser::Events');

=head1 NAME

EventBot::MailParser

=head1 SYNOPSIS

Given a raw email, this module does what is neccessary to convert it into plain
text, and then hands off the content to further parsing modules, and eventually
returns a list of detected significant.. stuff.

  use EventBot::MailParser;
  my $parser = EventBot::MailParser->new;
  $parser->parse($raw_email);
  my $detected = $parser->commands;
  my $from = $parser->from;

Results like:

  [
    {
      type => 'vote',
      data => ['a', 'b', 'c', 'd']
    },
    {
      type => 'attendance',
      data => '+john (running late)'
    },
  ]

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;
    $self->commands([]);
    return $self;
}

sub parse {
    my ($self, $raw) = @_;

    my $email = Email::Simple->new($raw);
    $self->from($email->header('From'));

    my $body = $email->body;

    for (@PARSERS) {
        my $result = $_->parse($body);
        $self->_add_command($result) if $result;
    }
}
    
sub _add_command {
    my ($self, $new) = @_;
    $self->commands([
        @{$self->commands},
        $new
    ]);
    return $new;
}

1;
