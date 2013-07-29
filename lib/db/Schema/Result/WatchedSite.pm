use utf8;
package db::Schema::Result::WatchedSite;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

__PACKAGE__->table("watched_sites");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "site_name",
  { data_type => "text", is_nullable => 0 },
);

__PACKAGE__->add_unique_constraint("site_unique", ["site_name"]);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->meta->make_immutable;
1;
