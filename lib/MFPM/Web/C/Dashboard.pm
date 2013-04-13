package MFPM::Web::C::Dashboard;
use strict;
use warnings;

sub index {
    my($self, $c) = @_;
    return $c->render('dashboard/index.tt');
};

1;

