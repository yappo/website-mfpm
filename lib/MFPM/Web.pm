package MFPM::Web;
use strict;
use warnings;
use utf8;
use parent qw/MFPM Amon2::Web/;
use File::Spec;

# dispatcher
use MFPM::Web::Dispatcher;
sub dispatch {
    return (MFPM::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::CSRFDefender' => {
        post_only => 1,
    },
    'Web::Auth' => {
        module => 'Github',
        on_finished => sub {
            my ($c, $token, $user) = @_;
            use Data::Dumper;warn Dumper(\@_);
            my $name = $user->{name} || die;
            $c->session->set('user' => $user);
            $c->session->set('github_token' => $token);
            return $c->redirect('/');
        },
        authenticate_path => '/account/login',
    },
);

# setup view
use MFPM::Web::View;
{
    my $view = MFPM::Web::View->make_instance(__PACKAGE__);
    sub create_view { $view }
}

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

__PACKAGE__->add_trigger(
    BEFORE_DISPATCH => sub {
        my ( $c ) = @_;
        # ...
        return;
    },
);

sub user {
    my $c = shift;
    return unless $c->session->get('user');
    $c->session->get('user');
}

1;
