use Mojo::Base -strict;

use Test::My::TestAppV3;
use FindBin qw/ $Bin /;
use Test::More;
use JSON::MaybeXS;

my $framework = Test::My::TestAppV3->new(
  etc_dir => "$Bin/etc",
  fixture => 'simple',
);
my $mech = $framework->mech;

$mech->get_ok( 'http://localhost/' );
$mech->content_contains( 'Hello world' );

$mech->get_ok( 'http://localhost/fruit' );
my $data = decode_json $mech->content;

is_deeply $data, {
  'fruit' => [
  {
    'name' => 'Apple',
      'id' => 1
  },
  {
    'name' => 'Pear',
    'id' => 2
  },
  {
    'id' => 3,
    'name' => 'Banana'
  },
  {
    'id' => 4,
    'name' => 'Pineapple'
  }
  ]
};

done_testing();
