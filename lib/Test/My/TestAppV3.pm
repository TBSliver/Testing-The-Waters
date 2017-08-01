package Test::My::TestAppV3;

use Moo;
use File::Temp;
use File::Spec;
use DBIx::Class::Fixtures;
use My::TestWsApp;
use LWP::Protocol::PSGI;
use Test::WWW::Mechanize;

has config_file => (
  is => 'lazy',
  builder => sub {
    my $file = File::Temp->new;

    print $file <<'END';
<db>
  dsn "dbi:SQLite::memory:"
  user
  pass
</db>
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

has app => (
  is => 'lazy',
  builder => sub {
    my $self = shift;

    $ENV{TEST_APP_CONFIG} = $self->config_file->filename;

    my $app = My::TestWsApp->new;
    $app->schema->deploy;
    $self->dbic_fixtures->populate({
      directory => $self->fixtures_data,
      no_deploy => 1,
      schema => $app->schema,
    });
    return $app;
  },
);

has mech => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    LWP::Protocol::PSGI->register($self->app->to_psgi_app);
    return Test::WWW::Mechanize->new;
  },
);

=pod

    my $self = shift;

    $ENV{TEST_APP_CONFIG} = $self->config_file->filename;

    my $app = Test::Mojo->new("My::TestApp");

    $t->app->schema->deploy;

    $self->dbic_fixtures->populate({
      directory => $self->fixtures_data,
      no_deploy => 1,
      schema => $t->app->schema,
    });

    return $t;
  },
);

=cut

1;
