package apanel::Controller::Books;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained('/base') PathPrefix CaptureArgs(0) {}

sub list : Chained('base') PathPart('list') Args(0) {
    my ($self, $c) = @_;

    $c->stash(books => [ $c->model('DB::Book')->all ]);
}

sub url_create : Chained('base') PathPart('url_create') Args(3) {
    my ($self, $c, $title, $rating, $author_id) = @_;

    my $book = $c->model('DB::Book')->create({
        title  => $title,
        rating => $rating
    });

    $book->add_to_book_authors({ author_id => $author_id });

    $c->stash(
        book     => $book,
        template => 'books/create_done.tt2'
    );

    $c->response->header('Cache-Control' => 'no-cache');
}




sub form_create : Chained('base') PathPart('form_create') Args(0) {
    my ($self, $c) = @_;

    $c->stash(template => 'books/form_create.tt2');
}




sub form_create_do : Chained('base') PathPart('form_create_do') Args(0) {
    my ($self, $c) = @_;

    my $title     = $c->request->params->{title}     || 'N/A';
    my $rating    = $c->request->params->{rating}    || 'N/A';
    my $author_id = $c->request->params->{author_id} || '1';

    my $book = $c->model('DB::Book')->create({
        title   => $title,
        rating  => $rating,
    });

    $book->add_to_book_authors({author_id => $author_id});

    $c->stash(
        book     => $book,
        template => 'books/create_done.tt2'
    );
}

sub object : Chained('base') PathPart('id') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->stash(object => $c->model('DB::Book')->find($id));

    die "Book $id not found!" if !$c->stash->{object};
}




sub delete : Chained('object') PathPart('delete') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->delete;

    $c->res->redirect($c->uri_for($self->action_for('list'),
        {status_msg => "Book deleted."}));
}




sub list_recent : Chained('base') PathPart('list_recent') Args(1) {
    my ($self, $c, $mins) = @_;

    $c->stash(books => [$c->model('DB::Book')
                            ->created_after(DateTime->now->subtract(minutes => $mins))]);

    $c->stash(template => 'books/list.tt2');
}




sub list_recent_tcp : Chained('base') PathPart('list_recent_tcp') Args(1) {
    my ($self, $c, $mins) = @_;

    $c->stash(books => [
            $c->model('DB::Book')
                ->created_after(DateTime->now->subtract(minutes => $mins))
                ->title_like('TCP')
        ]);

    $c->stash(template => 'books/list.tt2');
}

__PACKAGE__->meta->make_immutable;

1;