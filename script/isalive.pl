use strict;
use warnings;
use v5.14;

use Email::Sender::Simple qw(sendmail);
use Email::Simple::Creator; # or other Email::
use Email::Sender::Transport::SMTP::TLS;
use Try::Tiny;
use Mojo::UserAgent;
use File::Touch;
use FindBin;

my $me = 'ynonperek@gmail.com';
my $ahiad = 'kalisher@gmail.com';

my @websites = (
  { url => 'mobileweb.ynonperek.com', to => [ $me ] },
  { url => 'ynonperek.com',           to => [ $me ] },

  { url => 'ronenkook.co.il',   to => [ $ahiad ] },
  { url => 'didactive.org.il',  to => [ $ahiad ]},
  { url => 'gzahav.com',        to => [ $ahiad ]},
  { url => 'hostdyn.com',       to => [ $ahiad ]},
  { url => 'morgah-studio.com', to => [ $ahiad ]},
  { url => 'pockets.co.il',     to => [ $ahiad ]},
  { url => 't-vuch.co.il',      to => [ $ahiad ]},
  { url => 'artcenter.co.il',   to => [ $ahiad ]},
  { url => 'gozali.co.il',      to => [ $ahiad ]},
);

sub report_error_for_website {
  my ( $url, $to ) = @_;
# Website's down - warn by mail
  my $transport = Email::Sender::Transport::SMTP::TLS->new(
    host => 'smtp.gmail.com',
    port => 587,
    username => 'qtcollege@gmail.com',
    password => 'thur8pRA',
    helo => 'fayland.org',
  );

  my $message = Email::Simple->create(
    header => [
      From    => 'qtcollege@gmail.com',
      To      => $to,
      Subject => "$url Site Problem",
    ],
    body => "$url returned the wrong HTTP status code. Please check if it's still alive",
  );

  try {
    sendmail($message, { transport => $transport });
  } catch {
    die "Error sending email: $_";
  };

}

touch "/tmp/isalive.running";

my $ua = Mojo::UserAgent->new;

# Check if website is still up
foreach my $website (@websites) {
  next if $ua->get($website->{url})->res->code == 200;

  report_error_for_website( $website->{url}, join(',', @{$website->{to}}));
}


