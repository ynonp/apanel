use strict;
use warnings;

use Config::General;

use lib 'lib';
use db::Schema;

my $conf = Config::General->new("apanel.conf");

use Data::Dumper;
print Dumper( $conf );
