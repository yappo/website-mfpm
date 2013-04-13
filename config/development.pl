use strict;
use warnings;
use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));


my $dbpath = File::Spec->catfile($basedir, 'db', 'development.db');

my $common_config = do File::Spec->catfile($basedir, 'config', 'common.pl');
+{
    %{ $common_config },
    'DBI' => [
        "dbi:mysql:dbname=mfpm", 'root', '',
        +{
            PrintError           => 0,
            RaiseError           => 1,
            AutoCommit           => 1,
            AutoInactiveDestroy  => 1,
            ShowErrorStatement   => 1,
            mysql_enable_utf8    => 1,
            mysql_auto_reconnect => 0,
        }
    ],
};
