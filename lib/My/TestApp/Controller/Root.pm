package My::TestApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $c = shift;

  $c->render( text => 'Hello World' );
}

1;
