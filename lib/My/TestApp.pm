package My::TestApp;
use Mojo::Base 'Mojolicious';

use My::TestApp::Schema;

has schema => sub {
  my $self = shift;
  return My::TestApp::Schema->connect(
    $self->app->config->{dsn},
    $self->app->config->{user},
    $self->app->config->{pass},
    { quote_names => 1 },
  );
};

sub startup {
  my $self = shift;

  $self->plugin('Config');

  $self->helper( schema => sub {
    return $self->schema;
  });

  $self->routes->get('/')->to('root#index');
  $self->routes->get('/fruit')->to('root#fruit');
}

1;
