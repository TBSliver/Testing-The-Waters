package My::TestApp::Schema::Result::Fruit;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('fruits');

__PACKAGE__->add_columns(
  "id" => {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name" => {
    data_type => "text",
    is_nullable => 1,
  },
);

1;
