package Test::My::TestAppV1;

use Moo;
use File::Temp;

has config_file => (
  is => 'lazy',
  builder => sub {
    my $file = File::Temp->new;

    print $file <<'END';
{
  dsn => "dbi:SQLite::memory:",
  user => undef,
  pass => undef,
}
END

    $file->seek( 0, SEEK_END );
    return $file;
  },
);

has mojo => (
  is => 'lazy',
  builder => sub {
    my $self = shift;

    $ENV{MOJO_CONFIG} = $self->config_file->filename;

    my $t = Test::Mojo->new("My::TestApp");
    return $t;
  },
);

1;
