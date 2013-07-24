#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'apanel';
all_from 'lib/apanel.pm';

requires 'Catalyst::Runtime' => '5.90042';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats


# Extra modules for user management
requires 'DBIx::Class::PassphraseColumn';
requires 'Authen::Passphrase::BlowfishCrypt';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema::Loader';
requires 'DBIx::Class::TimeStamp';

requires 'MooseX::MarkAsMethods';
requires 'MooseX::NonMoose';
requires 'CatalystX::SimpleLogin';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Session::Store::FastMmap.pm';
requires 'Catalyst::Authentication::Store::DBIx::Class';

requires 'DBIx::Class::Cursor::Cached';
requires 'Catalyst::Plugin::StackTrace';

##################

requires 'Apache::Admin::Config';

###################
# Twitter bootstrap
requires 'Catalyst::Helper::View::Bootstrap';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
