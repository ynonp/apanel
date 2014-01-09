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
  my ( $self, $c ) = @_;
  return if ! -f '/etc/init.d/tomcat6';

  my $ok = system('sudo', '/etc/init.d/tomcat6', 'restart');
  $c->res->body("Restart result: $ok");
}

sub log : Chained('base') PathPart Args(0) GET {
  my ( $self, $c ) = @_;

  open my $fh, '<', '/var/log/tomcat6/catalina.out' or die 'Failed to open log file';
  $c->res->body($fh);
}


1;
