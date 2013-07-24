package apanel::Model::ApacheSites;
use Moose;
use List::Util qw/first/;

extends 'Catalyst::Model';

use strict;
use warnings;
use Apache::Admin::Config;

has 'data', is => 'ro', isa => 'Apache::Admin::Config', lazy_build => 1;

sub get_vhost {
  my ( $self, $site_name ) = @_;

  my @sections = $self->data->section( -name => 'virtualhost' );
  my $vhost = first { $_->directive('ServerName') eq $site_name } @sections;

  return $vhost;
}

sub _build_data {
  my ( $self ) = @_;
  return Apache::Admin::Config->new("/etc/apache2/sites-available/ahiad") or die $Apache::Admin::Config::ERROR;
}

sub get_all_sites {
  my ( $self ) = @_;

  my @hosts = $self->data->section(-name => 'virtualhost');
  return map { +{
    domain_name => $_->directive('ServerName'),
    tomcat_name => $self->get_tomcat_name( $_ ),
    has_dir => $self->has_folder($_),
  } } @hosts;
}

sub get_tomcat_name {
  my ( $self, $host ) = @_;
  my $RE = qr { \^\$[ ]/(\w+)[ ]\[PT\] }x;

  my $rule = first { /$RE/ } map { $_->value } $host->directive('RewriteRule');

  my ( $name ) = $rule =~ /$RE/;

  return $name || "[???]";
}

sub has_folder {
  my ( $self, $host ) = @_;
  my $dir = $host->section('Directory')->value;
  return -d $dir;
}

sub get_info {
  my ( $self, $site_name ) = @_;

  my $info = $self->get_vhost( $site_name );
  return if ! $info;

  return {
    name => $info->directive('ServerName'),
    tomcat_name => $self->get_tomcat_name( $info ),
    dir_exists => $self->has_folder( $info ),
    dir_name => $info->section('Directory')->value,
  }
}

sub add_vhost {
  my ( $self, $name, $tomcat_name ) = @_;
  my $info = $self->get_info( $name );
  # site already exists
  return if $info;

  my $dir = "/home/ahiad/web/" . lc($tomcat_name);

  my $vhost = $self->data->add_section( VirtualHost => '*:80' );

  $vhost->add_directive(ServerAdmin=>'kalisher@gmail.com');
  $vhost->add_directive(ServerName=> $name);
  $vhost->add_directive(ServerAlias => 'www.' . $name );

  $vhost->add_directive(DocumentRoot=> $dir);

  $vhost->add_directive(JkMount => '/* ajp13_worker');
  $vhost->add_directive(RewriteEngine => 'On');
  $vhost->add_directive(RewriteRule => '^$ /' . $tomcat_name . ' [PT]');
  $vhost->add_directive(RewriteRule => '^/(.*) /' .  $tomcat_name . '/$1 [PT]');

  my $dir_section = $vhost->add_section('Directory', $dir );
  $dir_section->add_directive(Order => 'Allow,Deny');
  $dir_section->add_directive(Allow => 'from all');

  $self->data->save;
}


sub delete_vhost {
  my ( $self, $site_name ) = @_;

  my $vhost = $self->get_vhost( $site_name );
  return if ! $vhost;

  $vhost->delete;
  $self->data->save;
}

sub update {
  my ( $self, $site_name, $pname, $ptomcat ) = @_;

  my $vhost = $self->get_vhost( $site_name );

   if ( $pname ) {
      my $curr_name   = $vhost->directive('ServerName');
      if ( $pname ne $curr_name ) {
        $vhost->directive('ServerName')->set_value( $pname );
        $vhost->directive('ServerAlias')->set_value( "www.${pname}");
      }
   }

   if ( $ptomcat ) {
      my $curr_tomcat = $self->get_tomcat_name( $vhost );
      if ( $ptomcat ne $curr_tomcat ) {
        $_->delete for $vhost->directive('RewriteRule');

        $vhost->add_directive(RewriteRule => '^$ /' . $ptomcat . ' [PT]');
        $vhost->add_directive(RewriteRule => '^/(.*) /' .  $ptomcat . '/$1 [PT]');
      }
   }
   $self->data->save;
}



1;