package MFPM::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use  MFPM::Web::DispatcherDeclare qw/ get post /;

use Module::Find ();
my @controllers = Module::Find::useall('MFPM::Web::C');

# define roots here.
use Router::Simple::Declare;
my $router;
sub router_obj {
    $router = router {
        get  '/'                                         => 'Root#index';
        get  '/dashboard'                                => 'Dashboard#index';
        post '/account/logout'                           => 'Root#logout';
    };
}

sub dispatch {
    my($class, $c) = @_;
    my $req = $c->request;
    if (my $p = $class->router_obj->match($req->env)) {
        my $action = $p->{action};
        $c->{args} = $p;
        "@{[ ref Amon2->context ]}::C::$p->{controller}"->$action($c, $p);
    } else {
        $c->res_404();
    }
}

1;
