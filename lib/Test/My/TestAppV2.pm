package Test::My::TestAppV2;

use Moo;
use File::Temp;
use File::Spec;
use DBIx::Class::Fixtures;

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

has etc_dir => ( is => 'ro', required => 1 );

has fixture => ( is => 'ro', required => 1 );

has fixtures_config => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    return File::Spec->catfile(
      $self->etc_dir,
      'fixtures',
      'config',
    );
  },
);

has fixtures_data => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    return File::Spec->catfile(
      $self->etc_dir,
      'fixtures',
      'data',
      $self->fixture,
    );
  },
);

has dbic_fixtures => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    my $fixtures = DBIx::Class::Fixtures->new({
      config_dir => $self->fixtures_config,
    });
    return $fixtures;
  },
);

has mojo => (
  is => 'lazy',
  builder => sub {
    my $self = shift;

    $ENV{MOJO_CONFIG} = $self->config_file->filename;

    my $t = Test::Mojo->new("My::TestApp");

    $t->app->schema->deploy;

    $self->dbic_fixtures->populate({
      directory => $self->fixtures_data,
      no_deploy => 1,
      schema => $t->app->schema,
    });

    return $t;
  },
);

1;
