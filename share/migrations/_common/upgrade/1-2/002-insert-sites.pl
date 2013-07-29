use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  shift->schema
    ->resultset('WatchedSite')
    ->populate([
      ['id', 'site_name'],
      [1, 'ronenkook.co.il'],
      [2, 'aquafml.com'],
      [3, 'artcenter.co.il'],
      [4, 'didactive.org.il'],
      [5, 'gzahav.com'],
      [6, 'hostdyn.com'],
      [7, 'morgah-studio.com'],
      [8, 'pockets.co.il'],
      [9, 't-vuch.co.il'],
      [10, 'gozali.co.il'],
      [11, 'kalisher.co.il'],
  ]);
};