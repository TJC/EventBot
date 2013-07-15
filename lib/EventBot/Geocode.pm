package EventBot::Geocode;
use 5.16.0;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw( :all );
use LWP::UserAgent;
use URI::Escape qw(uri_escape);
use JSON;

has 'geocode_url' => (
    is => 'rw',
    isa => Str,
    default => 'http://maps.googleapis.com/maps/api/geocode/json',
);

has 'region' => (
    is => 'rw',
    isa => Str,
    default => 'uk',
);

sub address {
    my ($self, $address) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(5);
    my $params = join('&',
        "address=" . uri_escape($address),
        'sensor=false',
        'region=' . $self->region
    );
    my $url = join('?', $self->geocode_url, $params);
    my $response = $ua->get($url);

    my $json = JSON->new;
    my $result = $json->decode($response->content);

    die("Failed: " . $result->{status} . "\n")
        unless ($result->{status} eq 'OK');

    return $result->{results}->[0]->{geometry}->{location};
}

__PACKAGE__->meta->make_immutable;
1;
