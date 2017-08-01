package My::TestApp;
use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;

  $self->plugin('Config');

  $self->routes->get('/')->to('root#index');
}

1;
