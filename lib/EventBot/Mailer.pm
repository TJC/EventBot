package EventBot::Mailer;
use 5.16.0;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw( :all );
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP qw();
use EventBot (); # required for config; TODO properly; XXX circular dep
use Carp qw(croak);

has 'from_addr' => (
    is => 'rw',
    isa => Str,
    lazy => 1,
    default => sub {
        shift->eventbot->from_addr
    },
);

has 'list_addr' => (
    is => 'rw',
    isa => Str,
    lazy => 1,
    default => sub {
        shift->eventbot->list_addr
    },
);

has 'eventbot' => (
    is => 'rw',
    lazy => 1,
    default => sub {
        EventBot->new
    },
);


# TODO: Convert this function to use Template::Toolkit instead of inline
# text..
sub new_event {
    my ($self, %args) = @_;
    my $event = $args{event};
    my $subject = $args{subject};

    my $date = $event->date_obj->strftime('%Y-%m-%d');
    my $time = $event->starttime;
    my $place = $event->place;
    my $url = $event->url;
    my $id = $event->id;

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

    $self->mailout($body, Subject => $subject);
    return;
}

# Send an email.
# Mandatory $body parameter, then args are: To, Subject, the former of which is optional and will
# default to mailing the list.
sub mailout {
    my ($self, $body, %args) = @_;

    croak "Missing Subject argument" unless defined $args{Subject};

    my $email = Email::Simple->create(
        header => [
            From => $self->from_addr,
            To   => $args{To} // $self->list_addr,
            Subject => $args{Subject},
        ],
        body => $body
    );

    # Do not *actually* send email if we're testing:
    return if $ENV{EVENTBOT_TEST};

    my $botcfg = $self->eventbot->config;
    sendmail(
        $email,
        {
            from => $botcfg->{imap}{email},
            transport => Email::Sender::Transport::SMTP->new({
                host => 'smtp.gmail.com',
                port => 465,
                sasl_username => $botcfg->{imap}{email},
                sasl_password => $botcfg->{imap}{passwd},
                ssl => $botcfg->{imap}{use_ssl}
            })
        }
    );
}

1;
