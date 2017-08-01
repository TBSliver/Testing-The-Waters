use Mojo::Base -strict;

use Test::My::TestAppV2;
use FindBin qw/ $Bin /;
use Test::More;
use Test::Mojo;

my $framework = Test::My::TestAppV2->new(
  etc_dir => "$Bin/etc",
  fixture => 'simple',
);
my $t = $framework->mojo;

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
