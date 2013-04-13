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

1;
