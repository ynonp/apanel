package apanel::Controller::Tomcat;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

# Before all
sub base : Chained('/base') PathPrefix CaptureArgs(0) {
  my ( $self, $c) = @_;
  $c->stash->{username} = $c->user->username;
}

# POST /tomcat/restart
sub restart : Chained('base') PathPart Args(0) POST {
  return if ! -f '/etc/init.d/tomcat6';

  system('sudo', '/etc/init.d/tomcat6', 'restart');
}

1;