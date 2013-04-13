package MFPM::Web::ViewFunctions;
use strict;
use warnings;
use utf8;
use parent qw(Exporter);
use Module::Functions;
use File::Spec;
use Text::Xslate;

our @EXPORT = get_public_functions();

sub commify {
    local $_  = shift;
    1 while s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s;
    return $_;
}

sub c { MFPM->context() }
sub uri_with { MFPM->context()->req->uri_with(@_) }
sub uri_for { MFPM->context()->uri_for(@_) }

{
    my %static_file_cache;
    sub static_file {
        my $fname = shift;
        my $c = MFPM->context;
        if (not exists $static_file_cache{$fname}) {
            my $fullpath = File::Spec->catfile($c->base_dir(), $fname);
            $static_file_cache{$fname} = (stat $fullpath)[9];
        }
        return $c->uri_for(
            $fname, {
                't' => $static_file_cache{$fname} || 0
            }
        );
    }
}

sub like_location {
    my $path = shift;
    MFPM->context->req->uri->path =~ m{^$path};
}

sub is_login { !! MFPM->context->user }
sub user { MFPM->context->user }

sub l {
    my $base = shift;
    my @args = map { Text::Xslate::html_escape $_ } @_; # escape arguments
    Text::Xslate::mark_raw(MFPM->context->loc($base, @args));
}

1;
