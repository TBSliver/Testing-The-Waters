package My::TestApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $c = shift;

  $c->render( text => 'Hello World' );
}

sub fruit {
  my $c = shift;

  my $fruit_rs = $c->schema->resultset('Fruit')->search( undef, { order_by => 'id' } );
  $c->render( json => {
    fruit => [
      ( map { { id => $_->id, name => $_->name } } $fruit_rs->all )
    ],
  });
}

1;
