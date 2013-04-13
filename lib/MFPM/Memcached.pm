package MFPM::Memcached;
use strict;
use warnings;
use utf8;
use parent qw(Cache::Memcached::Fast::Safe);

sub get_or_set {
    my($self, $key, $sub, $expire) = @_;
    if (my $value = $self->get($key)) {
        return $value;
    }
    my ($value, $ret_expire) = $sub->();
    $self->set($key, $value, $expire || $ret_expire);
    $value;
}

1;
