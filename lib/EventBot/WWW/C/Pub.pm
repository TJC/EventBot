# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::WWW::C::Pub;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::C::Pub

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 pub_region

Start of chain..

Takes parameter of region, which can also be "all".

=cut

sub pub_region :Chained PathPart('pub') CaptureArgs(1) {
    my ($self, $c, $region) = @_;
    $c->stash->{region} = $region;
}

=head2 pub_name

Get the pub name from the URL and then load it.

=cut

sub pub_name :Chained('pub_region') PathPart('') CaptureArgs(1) {
    my ($self, $c, $name) = @_;
   
    $c->stash->{pub} = $c->model('DB::Pubs')->search(
        {
            name => $name,
            region => $c->stash->{region}
        }
    )->next;
}

sub pub_details :Chained('pub_name') PathPart('') Args(0) {
    my ($self, $c) = @_;

    # view the pub details..

}

# View all pubs in region:
sub pub_region_list :Chained('pub_region') PathPart('') Args(0) {
    my ($self, $c) = @_;

    my %where = ();
    if ($c->stash->{region} ne 'all') {
        $where{region} = $c->stash->{region};
    }
    $c->stash->{pubs} = $c->model('DB::Pubs')->search(
        \%where,
        { order_by => 'region, name' }
    );
}

sub region_list : Chained PathPart('pub') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{regions} =
      $c->model('DB::Pubs')->search(
        {},
        {
            columns => ['region'],
            group_by => ['region'],
            order_by => 'region',
        }
    );
}

=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
