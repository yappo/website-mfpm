package MFPM;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.016;

__PACKAGE__->load_plugin('Web::Auth', {
    module => 'Github',
    on_finished => sub {
        my ($c, $token, $user) = @_;
        use Data::Dumper;warn Dumper(\@_);

        my $name = $user->{name} || die;
        $c->session->set('name' => $name);
        $c->session->set('site' => 'github');
        return $c->redirect('/');
    }
});

# initialize database
use DBI;
sub dbh {
    my $c = shift;
    $self->{dbh} //= DBI->connect(@{ $c->config->{DBI} });
}

1;
