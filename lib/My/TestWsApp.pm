package My::TestWsApp;

use Web::Simple;
use My::TestApp::Schema;
use Config::General;
use JSON::MaybeXS;

has config => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    my $conf = Config::General->new( $ENV{TEST_APP_CONFIG} || 'config.conf' );
    return { $conf->getall };
  }
);

has schema => (
  is => 'lazy',
  builder => sub {
    my $self = shift;
    return My::TestApp::Schema->connect(
      $self->config->{db}->{dsn},
      $self->config->{db}->{user},
      $self->config->{db}->{pass},
      { quote_names => 1 },
    );
  },
);

use Data::Dumper;
sub dispatch_request {
  my $self = shift;
  'GET + /' => sub {
    [ 200, [ 'Content-type', 'text/plain' ], [ 'Hello world!' ] ]
  },
  'GET + /fruit' => sub {
    my $fruit_rs = $self->schema->resultset('Fruit')->search( undef, { order_by => 'id' } );
    [ 200, [ 'Content-type', 'text/plain' ], [ encode_json {
      fruit => [
        ( map { { id => $_->id, name => $_->name } } $fruit_rs->all )
      ],
    } ] ]
  },
  '' => sub {
    [ 405, [ 'Content-type', 'text/plain' ], [ 'Method not allowed' ] ]
  };
}

__PACKAGE__->run_if_script;
