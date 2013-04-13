package MFPM;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.016;

# initialize database
use DBI;
sub dbh {
    my $c = shift;
    $c->{dbh} //= DBI->connect(@{ $c->config->{DBI} });
}

use MFPM::L10N;
{
    my %langs = (
        ja => MFPM::L10N->get_handle('ja'),
        en => MFPM::L10N->get_handle('en'),
    );
    sub lang {
        my ($c) = @_;
        return 'ja' if ($c->session->get('lang') || 'en') eq 'ja';
        return 'ja' if ($c->req->param('lang') || 'en') eq 'ja';
        return 'ja' if ($c->req->header('Accept-Language') || 'en') =~ /ja/;
        return 'en';
    }
    sub l10n {
        my ($c) = @_;
        $langs{$c->lang};
    }
}
sub loc {
    shift->l10n->maketext(@_)
}

1;
