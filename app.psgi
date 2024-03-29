use strict;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;

use MFPM::Web;
use MFPM;
use MFPM::Memcached;
use Plack::Session::Store::Cache;
use Plack::Session::State::Cookie;
use DBI;

my $c = MFPM->new();
my $db_config = $c->config->{DBI} || die "Missing configuration for DBI";
builder {
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/static/)},
        root => File::Spec->catdir(dirname(__FILE__));
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/robots\.txt|/favicon\.ico)$},
        root => File::Spec->catdir(dirname(__FILE__), 'static');
    enable 'Plack::Middleware::ReverseProxy';
    enable 'Plack::Middleware::Session',
        store => Plack::Session::Store::Cache->new(
            cache => MFPM::Memcached->new($c->config->{CACHE}),
        ),
        state => Plack::Session::State::Cookie->new(
            httponly => 1,
        );
    MFPM::Web->to_app();
};
