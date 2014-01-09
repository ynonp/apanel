package apanel::Controller::Sites;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }


# Before all
sub base : Chained('/base') PathPrefix CaptureArgs(0) {
  my ( $self, $c) = @_;
  $c->stash->{current_model_instance} = $c->model('ApacheSites');
  $c->stash->{username} = $c->user->username;
}

# GET /sites
sub list : Chained('base') PathPart('') Args(0) {
  my ($self, $c) = @_;
  my @watched = $c->model("DB::WatchedSite")->search->all;

  $c->stash->{watched}->{$_->site_name} = 1 for @watched;
  $c->stash->{sites} = [ $c->model->get_all_sites ];
}

# GET /sites/edit/:site_name
sub edit :Chained('base') PathPart Args(1) GET {
  my ( $self, $c, $site_name ) = @_;

  my $site_data = $c->model->get_info( $site_name );
  if ( $c->model('DB::WatchedSite')->find({ site_name => $site_name }) ) {
    $site_data->{watched} = 1;
  }


  die "Invalid site: $site_name" if ! $site_data;

  $c->stash->{info} = $site_data;

}

# POST /sites/edit/:site_name
sub doEdit :Chained('base') PathPart('edit') Args(1) POST {
  my ( $self, $c, $site_name ) = @_;

  my $pname   = $c->req->param('site_name');
  my $ptomcat = $c->req->param('tomcat_name');
  my $pwatch   = $c->req->param('watch');

  die "Invalid site name: $pname"     if $pname   && $pname   !~ /^[-0-9a-z.]+$/;
  die "Invalid tomcat name: $ptomcat" if $ptomcat && $ptomcat !~ /^[\w.]+$/;

  if ( $pwatch ) {
    $c->model('DB::WatchedSite')->find_or_create({ site_name => $site_name });
  } else {
    my $row = $c->model('DB::WatchedSite')->find({ site_name => $site_name });
    $row->delete if $row;
  }

  $c->model->update( $site_name, $pname, $ptomcat );
  $c->res->redirect('/sites');
}

# GET /sites/create
sub create :Chained('base') PathPart GET Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{template} = 'sites/edit.tt2';
}

# POST /sites/create
sub doCreate :Chained('base') PathPart('create') POST Args(0) {
  my ( $self, $c ) = @_;

  my $name = $c->req->param('site_name') or die 'Missing site name';
  my $tomcat_name = $c->req->param('tomcat_name') or die 'Missing tomcat name';

  $c->model->add_vhost( $name, $tomcat_name );
  system("sudo", "/etc/init.d/apache2",  "reload");
  $c->res->redirect('/sites');
}

# POST /sites/createdir
sub doCreateDir :Chained('base') PathPart('createdir') POST Args(0) {
  my ( $self, $c ) = @_;
  my $name = $c->req->param('site_name') or die 'Missing site name';
  my $info = $c->model->get_info( $name ) or die 'Site not found: ' . $name ;

  mkdir $info->{dir_name} or die $!;
  my $mode = 0775;

  chmod $mode, $info->{dir_name};
  if ( $info->{dir_name} =~ /^[\/a-z ]+$/ ) {
    system('/bin/chgrp', 'tomcat6', $info->{dir_name});
  }

  $c->res->redirect('/sites/edit/' . $name);
}

# POST /sites/delete/:site_name
sub delete :Chained('base') PathPart POST Args(1) {
  my ( $self, $c, $site_name ) = @_;

  $c->model->delete_vhost( $site_name );
  $c->res->redirect('/sites');
}

1;



