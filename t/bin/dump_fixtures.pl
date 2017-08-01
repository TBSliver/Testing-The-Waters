#! /usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Fixtures;
use FindBin qw/ $Bin /;
use My::TestApp::Schema;

my $fixtures = DBIx::Class::Fixtures->new({
  config_dir => "$Bin/../etc/fixtures/config",
});

my $schema = My::TestApp::Schema->connect('dbi:SQLite::memory:');

$schema->deploy;

$schema->resultset('Fruit')->populate([
  [ qw/ id name / ],
  [ qw/ 1 Apple / ],
  [ qw/ 2 Pear / ],
  [ qw/ 3 Banana / ],
  [ qw/ 4 Pineapple / ],
]);

my $data_set = 'simple';

$fixtures->dump({
  all => 1,
  schema => $schema,
  directory => "$Bin/../etc/fixtures/data/" . $data_set,
});
