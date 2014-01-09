package apanel::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub base : Chained('/login/required') PathPart('') CaptureArgs(0) {}

sub home : Chained('/base') PathPart('') Args(0) {
    my ($self, $c) = @_;

    $c->res->redirect($c->uri_for('/sites'));
}

sub default : Chained('/base') PathPart('') Args {
    my ($self, $c) = @_;
    $c->res->body('Page not found');
    $c->res->status(404);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
