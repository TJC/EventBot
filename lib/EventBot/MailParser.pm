package EventBot::MailParser;
use strict;
use warnings;
use parent 'Class::Accessor';
use Mail::Address;
use Email::MIME;
use EventBot::MailParser::Votes;
use EventBot::MailParser::NewEvent;
use EventBot::MailParser::Attend;
use List::Util qw(first);

__PACKAGE__->mk_accessors(qw(commands from subject));

our @PARSERS = (qw(
    EventBot::MailParser::Votes
    EventBot::MailParser::Attend
    EventBot::MailParser::NewEvent
));

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

Results should look like:

  [
    {
      type => 'vote',
      votes => ['a', 'b', 'c', 'd']
    },
    {
      type => 'attendance',
      name => 'John Smith',
      mode => '+',
      event => 205,
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

    my $email = Email::MIME->new($raw);
    my @parts = $email->parts;
    my $plain_part;
    if (@parts > 1) {
        # Then we need to pick the correct one..
        $plain_part = first { $_->content_type =~ m{text/plain}i } @parts;
        die "Failed to locate plain text component of email!"
            unless $plain_part;
    }
    else {
        # Just go with the top-level object:
        $plain_part = $email;
    }

    my ($sender) = Mail::Address->parse($email->header('From'));
    $self->from($sender);

    $self->subject($email->header('Subject'));

    my $body = $plain_part->body;

    for (@PARSERS) {
        my @results = $_->parse($self->subject, $body);
        for (@results) {
            $self->_add_command($_);
        }
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
