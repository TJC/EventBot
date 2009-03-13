package EventBot;

use 5.008001;
use strict;
use warnings;

use Mail::Address;
use Email::Simple;
use Email::Simple::Creator;
use Email::Send;
use EventBot::Schema;
#use Data::Dumper;

our $VERSION = '0.20';

sub new {
    my ($class, $args) = @_;
    my $self = {};
    $self->{logfile} = $args->{logfile};
    $self->{schema} = EventBot::Schema->connect(
        'dbi:Pg:dbname=eventbot', undef, undef,
        {
            AutoCommit => 1,
            pg_enable_utf8 => 1,
            pg_server_prepare =>1
        }
    );
    return bless $self, $class;
}

sub schema {
    return $_[0]->{schema};
}

sub parse_email {
    my ($self, $email) = @_;
    my ($sender, $event_id);
    die("need email object") 
        unless (ref $email and $email->isa('Email::Simple'));

    eval {
        ($sender) = Mail::Address->parse($email->header("From"));
    };
    if ($@ or not ref $sender) {
        $self->log("Error parsing From address: " . $email->header("From"));
        return;
    }

    $self->log("Parsing email from " . $sender->address);
    $self->{sender} = $sender->address;
    $self->{subject} = $email->header('Subject');

    if ($self->{subject} =~ /\[event (\d+)\]/i) {
        $event_id = $1;
        $self->log("Suspected event ID: $event_id");
    }

    my @lines = split("\n", $email->body);
    my (%vars, %attendees);
    foreach my $line (@lines) {
        # Detect election votes:
        if (my @votes = $line =~
            /^
            \s*
            I\svote\s*:\s*
            ([A-Za-z])\s*
            ([A-Za-z])?\s*
            ([A-Za-z])?\s*
            ([A-Za-z])?\s*
            /x
        ) {
            $self->log("Found votes: " . join(', ', @votes));
            return $self->do_votes($sender, @votes);
        }

        # Detect events:
        if (my (undef, $key, $val) = $line =~
          /^
          (\s*>\s*)*
          (\w{2,8})
          :\s+
          ([[:print:]]+)
          $/x) {
            $val =~ s/\s*$//;
            $key = lc($key);
            $vars{$key} = $val;
        }
        # Detect attendance notices:
        elsif (my($mode, $name) = $line =~
          /^\s*
          ([-\+\?])
          \s*
          [`']?
          ([\w\d][[:print:]]+?)
          [`']?
          \s*$
          /x) {
            $attendees{$name} = $mode;
            $self->log("Located attendee: $name");
        }
    }

    # Attempt to locate event based on event id, or the date/time/place:
    my $event;
    if ($event_id) {
        $event = $self->schema->resultset('Events')->find($event_id);
    }
    elsif ( $vars{date} and $vars{time} and $vars{place} ) {
        $event = $self->find_event(\%vars);
    }
    else {
        $self->log("Insufficient details to create/locate event");
        return;
    }

    if (%attendees) {
        if (not $event) {
            $self->log("Can't add attendees as no existing event!");
            return;
        }
        $self->log("Appending attendees to existing event..");
        # Don't try to add a new event, just add people
        $self->schema->txn_do(sub {
            $event->add_people(%attendees);
        });
    }
    else {
        # Create a new event:
        $self->log("Creating a new event..");
        $self->create_event(\%vars);
    }
}

sub find_event {
    my ($self, $vars) = @_;
#    $self->log("Searching for event based on: " . Dumper($vars));
    my ($event) = $self->schema->resultset('Events')->search({
            startdate => $vars->{date},
            starttime => $vars->{time},
            place     => $vars->{place}
        });
    if (not $event) {
        $self->log("Could not locate event based on these details.");
    }
    return $event;
}

sub log {
    my ($self, $msg) = @_;
    if (defined $self->{logfile}) {
        $self->{logfile}->print("$msg\n");
    }
    else {
        print "Log: $msg\n";
    }
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
        $self->log("Event already exists..");
        return $event;
    }
    # Check that these vars are populated!
    unless ($vars->{'date'} and $vars->{'time'} and $vars->{place}) {
        $self->log("Cowardly refusing to create empty event!");
        return;
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
        delete $new{comments};
    }
    $event = $self->schema->resultset('Events')->create(\%new);
    $self->log("Created new event, id " . $event->id);
    # At this point, I should email the list to say..
    $self->mail_new_event($event);
    return $event;
}

sub mail_new_event {
    my ($self, $event) = @_;
    my ($date, $time, $place, $url, $id) = (
        $event->startdate, $event->starttime,
        $event->place, $event->url, $event->id
    );
    my $body = <<EOM;
New event added to database:
Date: $date
Time: $time
Place: $place
Link: $url

To indicate that you're attending this event, reply to this email and add a
line with "+ Yourname" (without the quotes). You can indicate that you're not
sure, or are not coming, by using the minus and question mark characters at the
start instead. You can change your status later by sending a new message.
Note that the +, - or ? must be at the very start of the line.
Put multiple attendees on individual lines.

To view the attendance record, visit http://eventbot.dryft.net/event/view/$id

-- 
Yours faithfully,
EventBot
http://eventbot.dryft.net/

EOM
    my $subject = $self->{subject};
    $subject =~ s/^re:\s+//i;
    $subject =~ s/\s*\[event\s*\d*\s*\]\s*//i;
    $subject =~ s/\s*\[sluts]\s*//;
    $subject = "[EVENT $id] " . $subject;
    my $email = Email::Simple->create(
        header => [
            From => 'eventbot@dryft.net',
            To   => 'sluts@twisted.org.uk',
            Subject => $subject
        ],
        body => $body
    );

    Email::Send->new({mailer => 'Sendmail'})->send($email->as_string);
#    my $mailer = Email::Send->new({mailer => 'SMTP'});
#    $mailer->mailer_args([ Host => 'localhost' ]);
#    $mailer->send($email->as_string);
}

=head2 do_votes

Handle incoming votes for current election!

voter==Mail::Address

=cut

sub do_votes {
    my ($self, $voter, @votes) = @_;

    my $person = $self->schema->resultset('People')->find_or_create(
        {
            email => $voter->address,
            name => ($voter->name || $voter->address)
        }
    );
    $person->name($voter->name || $voter->address);
    $person->update;

    my $vote = uc(shift @votes);

    # Get the most recent enabled election:
    my $election = $self->schema->resultset('Elections')->search(
        { enabled => 1 },
        { order_by => 'id DESC' }
    )->next;
    if (not $election) {
        $self->log("Erm, apparently no elections are running!");
        exit;
    }

    $election->vote($vote, $person);
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
