# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot;
use 5.16.0;
use warnings;

use Carp qw(croak);
use Mail::Address;
use Config::General;
use EventBot::Schema;
use EventBot::MailParser;
use EventBot::Mailer;
use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(schema parser logfile from_addr list_addr));

our $VERSION = '2.00';

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;

    $self->logfile($args->{logfile});

    # Get addresses from config file
    croak("Config file not specified") unless $args->{config};
    my %config = Config::General->new($args->{config})->getall;
    die("Failed to read valid configuration!") unless %config;

    $self->from_addr($config{from_addr});
    $self->list_addr($config{list_addr});

    $self->schema( EventBot::Schema->connect(
        $config{database}->{dsn},
        $config{database}->{username},
        $config{database}->{password},
        {
            AutoCommit => 1,
            pg_enable_utf8 => 1,
        }
    ));

    return $self;
}

sub parse_email {
    my ($self, $email) = @_;
    my ($sender, $event_id);

    $self->parser(EventBot::MailParser->new);

    $self->parser->parse($email);

    $self->log("Parsing email from " . $self->parser->from->address);

    for my $command (@{$self->parser->commands}) {
        given($command->{type}) {
            when ('newevent') {
                $self->do_newevent($command);
            }
            when ('vote') {
                $self->do_votes($command);
            }
            when ('attend') {
                $self->do_attend($command);
            }
        }
    }
}

sub do_attend {
    my ($self, $details) = @_;
    my $event_id = $details->{event};
    my $event = $self->schema->resultset('Events')->find($event_id);
    if (not $event) {
        $self->log("Can't add attendees as event $event_id not found!");
        return;
    }

    $self->log("Adding attendee: " . $details->{name}
        . " to event ID " . $event->id
    );

    # TODO: Update API for adding new attendees?
    $event->add_people( $details->{name}, $details->{mode} );
}

# NOTE: This function is from previous version of eventbot..
sub find_event {
    my ($self, $vars) = @_;

    my $event = $self->schema->resultset('Events')->single({
        startdate => $vars->{date},
        starttime => $vars->{time},
        place     => $vars->{place}
    });

    $self->log("Could not locate event based on these details.")
        unless $event;

    return $event;
}

sub log {
    my ($self, $msg) = @_;
    if (defined $self->logfile and not $ENV{EVENTBOT_TEST}) {
        $self->logfile->print("$msg\n");
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
    'link' => 'url',
);

# NOTE: This function is from previous version of eventbot..
# I think I've migrated it across OK now.
sub do_newevent {
    my ($self, $vars) = @_;

    # Check that these vars are populated!
    unless ($vars->{'date'} and $vars->{'time'} and $vars->{place}) {
        $self->log("Cowardly refusing to create empty event!");
        return;
    }

    # Check if one already exists:
    my $event = $self->find_event($vars);
    if ($event) {
        $self->log("Event already exists..");
        return $event;
    }

    my %new;
    foreach (keys %$vars) {
        if (exists $keyconv{$_}) {
            $new{$keyconv{$_}} = $vars->{$_};
        }
    }

    # Kludge for comment->URL
    if (not $new{url}
        and $new{comments}
        and $new{comments} =~ /^(http:[^\s]+)/
    ) {
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
    my $id = $event->id;
    my $subject = $self->parser->subject;
    $subject =~ s/^re:\s+//i;
    $subject =~ s/\s*\[event\s*\d*\s*\]\s*//i;
    $subject =~ s/\s*\[sluts]\s*//;
    $subject = "[EVENT $id] " . $subject;

    EventBot::Mailer->new(
        from_addr => $self->from_addr,
        list_addr => $self->list_addr,
    )->new_event(
        event => $event,
        subject => $subject,
    );
}

=head2 do_votes

Handle incoming votes for current election!

voter==Mail::Address

=cut

sub do_votes {
    my ($self, $command) = @_;
    my @votes = @{$command->{votes}};
    my $voter = $self->parser->from;

    my $person = $self->schema->resultset('People')->find_or_create(
        {
            email => lc($voter->address),
            name => ($voter->name || $voter->address)
        }
    );
    # Update their name in case they've changed it:
    $person->name($voter->name || $voter->address);
    $person->update;

    # Make sure votes are uppercase:
    @votes = map { uc($_) } @votes;

    # Get the most recent enabled election:
    my $election = $self->schema->resultset('Elections')->current;
    if (not $election) {
        $self->log("Erm, apparently no elections are running!");
        return;
    }

    # Store all their votes, in order:
    # TODO: Implement full run-off elections.
    $election->vote(\@votes, $person);
}

1;
__END__

=head1 NAME

EventBot - Garner events and attendees from emails

=head1 SYNOPSIS

  use EventBot;
  my $bot = EventBot->new({
    logfile => IO::File->new('/some/file')
  });
  $bot->parse_email($text);

=head1 DESCRIPTION

Process emails to find events, attendance notices and votes.

=head2 EXPORT

None by default.

=head1 SEE ALSO

EventBot::Schema and EventBot::MailParser and EventBot::WWW

=head1 AUTHOR

Toby Corkindale, tjc@cpan.org

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006, 2009 by Toby Corkindale, all rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/

=cut
