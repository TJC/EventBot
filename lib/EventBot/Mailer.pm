package EventBot::Mailer;
use Moose;
use Email::Simple;
use Email::Simple::Creator;
use Email::Send;

has 'from_addr' => (
    is => 'rw',
    isa => 'Str',
);

has 'list_addr' => (
    is => 'rw',
    isa => 'Str',
);


# TODO: Convert this function to use Template::Toolkit instead of inline
# text..
sub new_event {
    my ($self, %args) = @_;
    my $event = $args{event};
    my $subject = $args{subject};

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

    my $email = Email::Simple->create(
        header => [
            From => $self->from_addr,
            To   => $self->list_addr,
            Subject => $subject
        ],
        body => $body
    );

    # Do not *actually* send email if we're testing:
    return if $ENV{EVENTBOT_TEST};

    Email::Send->new({mailer => 'Sendmail'})->send($email->as_string);

#    my $mailer = Email::Send->new({mailer => 'SMTP'});
#    $mailer->mailer_args([ Host => 'localhost' ]);
#    $mailer->send($email->as_string);
}



1;
