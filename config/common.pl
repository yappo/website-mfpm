use strict;
use warnings;
use Config::Pit;

+{
    'CACHE' => +{
        servers => [
            '127.0.0.1:11211'
        ],
        namespace => 'mfpm',
    },
    Auth => {
        Github => pit_get('mfpm.org.github', require => {
            client_id     => 'github client id',
            client_secret => 'github client secret',
        })
    },
};

