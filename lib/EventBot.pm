package EventBot;

use 5.008001;
use strict;
use warnings;

use Mail::Address;
use EventBot::Schema;

our $VERSION = '0.01';

sub new {
    my ($class, $args) = @_;
    my $self = {};
    $self->{schema} = EventBot::Schema->connect('dbi:Pg:dbname=eventbot');
    return bless $self, $class;
}

sub schema {
    return $_[0]->{schema};
}

sub parse_email {
    my ($self, $email) = @_;
    my $sender;
    die("need email object") 
        unless (ref $email and $email->isa('Email::Simple'));

    eval {
        ($sender) = Mail::Address->parse($email->header("From"));
    };
    if ($@ or not ref $sender) {
        mylog("Error parsing From address: " . $email->header("From"));
        return;
    }

    mylog("Parsing email from " . $sender->address);

    my @lines = split("\n", $email->body);
    my (%vars, %attendees);
    foreach my $line (@lines) {
        # Detect events:
        if ($line =~ /^(\s*>\s*)*(\w{2,8}):\s+([[:print:]]+)$/) {
            $vars{lc($2)} = $3;
        }
        # Detect attendance notices:
        elsif ($line =~ /^([-\+\?])\s*([\w\d][[:print:]]+)$/) {
            $attendees{$2} = $1;
        }
    }
    unless ( $vars{date} and $vars{time} and $vars{place} ) {
        mylog("Insufficient details to create/locate event");
        return;
    }
    if (%attendees) {
        mylog("Appending attendees to existing event..");
        # Don't try to add a new event, just add people
        my $event = $self->find_event(\%vars);
        if (not $event) {
            mylog("Couldn't locate event!");
            return;
        }
        $event->add_people(%attendees);
    }
    else {
        # Create a new event:
        mylog("Creating a new event..");
        $self->create_event(\%vars);
    }
}

sub find_event {
    my ($self, $vars) = @_;
    my ($event) = $self->schema->resultset('Events')->search({
            startdate => $vars->{date},
            starttime => $vars->{time},
            place     => $vars->{place}
        });
    if (not $event) {
        mylog("Could not locate event based on these details.");
    }
    return $event;
}

sub mylog {
    my $msg = shift;
    print "Log: $msg\n";
}

our %keyconv = (
    'date' => 'startdate',
    'time' => 'starttime',
    'place' => 'place',
    'url'  => 'url',
    'comments' => 'comments',
);

sub create_event {
    my ($self, $vars) = @_;
    # Check if one already exists:
    my $event = $self->find_event($vars);
    if ($event) {
        mylog("Event already exists..");
        return $event;
    }
    my %new;
    foreach (keys %$vars) {
        if (exists $keyconv{$_}) {
            $new{$keyconv{$_}} = $vars->{$_};
        }
    }
    # Kludge for comment->URL
    if (not $new{url} and $new{comments} =~ /^(http:[^\s]+)/) {
        $new{url} = $1;
    }
    $event = $self->schema->resultset('Events')->create(\%new);
    mylog("Created new event, id " . $event->id);
    return $event;
}

1;
__END__

=head1 NAME

EventBot - Garner events and attendees from emails

=head1 SYNOPSIS

  use EventBot;
  blah blah blah

=head1 DESCRIPTION

Blah blah blah.

=head2 EXPORT

None by default.

=head1 SEE ALSO

Associated web functionality (to be written).

=head1 AUTHOR

Toby Corkindale, E<lt>cpan@corkindale.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Toby Corkindale

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
