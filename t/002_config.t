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
$t->get_ok('/')->status_is(200);

done_testing();
