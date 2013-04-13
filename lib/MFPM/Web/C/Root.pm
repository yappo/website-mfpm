package MFPM::Web::C::Root;
use strict;
use warnings;

sub index {
    my($self, $c) = @_;
    return $c->render('index.tt');
}

sub logout {
    my($self, $c) = @_;
    $c->session->expire();
    return $c->redirect('/');
}

1;
