package MFPM::Web::DispatcherDeclare;
use strict;
use warnings;
use utf8;

our @ISA = 'Exporter';
our @EXPORT = qw/ any get post /;

use Router::Simple::Declare;

sub any($;$$)  { connect_with_method('', @_) }
sub get($;$$)  { connect_with_method(['HEAD', 'GET'], @_) }
sub post($;$$) { connect_with_method('POST', @_) }

sub connect_with_method {
    my ($method, $path, $dest, $opt) = @_;
    $opt ||= +{};
    $opt->{method} = $method;
    if (ref $dest) {
        connect $path => $dest, $opt;
    } elsif (not $dest) {
        connect $path => $opt;
    } else {
        my %dest;
        my($controller, $action) = split('#', $dest);
        $dest{controller} = $controller;
        $dest{action} = $action if defined $action;
        connect $path => \%dest, $opt;
    }
}

1;
