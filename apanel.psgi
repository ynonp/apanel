use strict;
use warnings;

use apanel;

my $app = apanel->apply_default_middlewares(apanel->psgi_app);
$app;

