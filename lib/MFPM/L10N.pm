package MFPM::L10N;
use strict;
use warnings;
use utf8;
use parent 'Locale::Maketext';

use MFPM;

use Locale::Maketext::Lexicon +{
    en       => [ 'Auto' ],
    ja       => [ Gettext => join('/', MFPM->base_dir, 'po', 'ja.po') ],
    _preload => 1,
    _auto    => $ENV{DEBUG_L10N} ? 0 : 1,
    _style   => 'gettext',
    _decode  => 1,
};

1;
