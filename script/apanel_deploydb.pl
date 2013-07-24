use strict;
use warnings;

use Config::General;

use lib 'lib';
use db::Schema;

my $conf = Config::General->new("apanel.conf");

my $connect_info = $conf->{DefaultConfig}->{"Model::DB"}->{connect_info};

my $db = db::Schema->connect( $connect_info );

$db->deploy();