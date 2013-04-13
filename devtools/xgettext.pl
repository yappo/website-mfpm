#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Locale::Maketext::Extract;
use Locale::Maketext::Extract::Plugin::Xslate;
use File::Find::Rule;

my $Ext = Locale::Maketext::Extract->new(
    plugins => {
        perl => [qw/pl pm js/],
        xslate  => {
            syntax     => 'TTerse',
            extensions => [qw/ tt /],
        },
    },
    warnings => 1,
    verbose => 1,
);
for my $lang (qw/en ja/) {
    $Ext->read_po("po/$lang.po") if -f "po/$lang.po";
    $Ext->extract_file($_) for File::Find::Rule->file()->name('*.(pm|pl)')->in('lib');
    $Ext->extract_file($_) for File::Find::Rule->file()->name('*.tt')->in('tmpl');
    $Ext->extract_file($_) for File::Find::Rule->file()->name('*.js')->in('htdocs/static/js/');
    $Ext->compile(1);
    $Ext->write_po("po/$lang.po");
}
