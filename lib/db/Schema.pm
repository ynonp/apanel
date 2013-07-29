use utf8;
package db::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-07-23 17:33:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7Wp4B76pXvVffMx24pCHug


# You can replace this text with custom code or comments, and it will be preserved on regeneration

our $VERSION = 2;

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
