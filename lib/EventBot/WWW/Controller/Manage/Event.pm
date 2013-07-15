# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::Controller::Manage::Event;
use strict;
use warnings;
use parent 'Catalyst::Controller::reCAPTCHA';
use EventBot::Mailer;

# This module should contain methods to create a one-off event for eventbot,
# which dispatches a confirmation email, and after that immediately submits the
# event.

sub event : Chained('/manage/manage_base') PathPart CaptureArgs(0) {
    my ($self, $c) = @_;
    # base event creation..
}

sub create :Chained('event') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{nominees} = $c->model('DB::People')->search(
        {},
        { order_by => 'name' }
    );
    $c->stash->{venues} = $c->model('DB::Pubs')->search(
        {},
        { order_by => 'name' }
    );
    $c->forward('captcha_get');
    return unless $c->request->method =~ /^POST/i;

    my %event;
    eval {
#        my $pub = $c->model('DB::Pubs')->find($c->request->params->{venue})
#            or die("Unknown pub\n");

        $c->stash->{subject} = $c->request->params->{subject}
            or die("Missing subject line.\n");
        $c->stash->{subject} =~ s/[^\w\d\s\!\-\=\+\_\.\@\#\$\%\&\*\(\)]+//g;

        die("Missing start date.\n") unless $c->request->params->{date};
        my $date = EventBot::Utils->figure_date(
            $c->request->params->{date}
        ) or die("Invalid date\n");
        $event{startdate} = $date->strftime('%Y-%m-%d');

        die("Missing nominee\n") unless $c->request->params->{nominee};
        my $nom = $c->model('DB::People')->find($c->request->params->{nominee})
            or die("Unknown nominee\n");

        $event{place} = $c->request->params->{venue_name}
            or die("No venue given.\n");

        $event{starttime} = $c->request->params->{starttime}
            or die("No start time given.\n");

        $event{url} = $c->request->params->{url};
        $event{comments} = $c->request->params->{comment};

        for my $field (qw(comments url starttime place)) {
            $event{$field} =~ s/</&lt;/g;
            $event{$field} =~ s/>/&gt;/g;
            die("$field is too long!\n") if (length($event{$field}) > 200);
        }

        $c->forward('captcha_check');
        die("Failed CAPTCHA: " . $c->stash->{recaptcha_error} .  "\n")
            unless ($c->stash->{recaptcha_ok});

        $c->stash->{event} = $c->model('DB::Events')->create(\%event);
    };
    if ($@) {
        $c->log->error("Failed to create event: $@");
        $c->stash->{message} = $@;
    }
    else {
        my $subject = sprintf('[EVENT %d] %s',
                              $c->stash->{event}->id,
                              $c->stash->{subject},
                          );
        EventBot::Mailer->new(
            from_addr => $c->config->{from_addr},
            list_addr => $c->config->{list_addr},
        )->new_event(
            subject => $subject,
            event => $c->stash->{event},
        );

        $c->response->redirect('/event/view/' . $c->stash->{event}->id);
    }
}

1;
