use Mojo::Base -strict;

use File::Temp;
use Test::More;
use Test::Mojo;

my $file = File::Temp->new;

print $file <<'END';
{
  dsn => "dbi:SQLite::memory:",
  user => undef,
  pass => undef,
}
END

$file->seek( 0, SEEK_END );

$ENV{MOJO_CONFIG} = $file->filename;

my $t = Test::Mojo->new("My::TestApp");

my $schema = $t->app->schema;
$schema->deploy;

$schema->resultset('Fruit')->populate([
  [ qw/ id name / ],
  [ qw/ 1 Apple / ],
  [ qw/ 2 Pear / ],
  [ qw/ 3 Banana / ],
  [ qw/ 4 Pineapple / ],
]);

$t->get_ok('/fruit')
  ->status_is(200)
  ->json_is({
    fruit => [
      { id => 1, name => 'Apple' },
      { id => 2, name => 'Pear' },
      { id => 3, name => 'Banana' },
      { id => 4, name => 'Pineapple' },
    ]
  });

done_testing();
