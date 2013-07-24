#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';

BEGIN { $ENV{CATALYST_DEBUG} = 0 }

use apanel;
use DateTime;

my $password = shift || 'admin';

my $admin = apanel->model('DB::User')->search({ username => 'admin' })
    ->single;

$admin->update({ password => $password, password_expires => DateTime->now });
