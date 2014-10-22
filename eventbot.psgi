use strict;
use Plack::Builder;
use EventBot::WWW;

builder {
    enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } "Plack::Middleware::ReverseProxy";
    EventBot::WWW->psgi_app(@_);
};

