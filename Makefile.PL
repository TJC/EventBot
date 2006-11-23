use inc::Module::Install;

name 'EventBot';
all_from 'lib/EventBot.pm';

requires	'Email::Simple'		=> 1.95;
requires	'Mail::Address'		=> 0.02; # figure out correct one
requires	'DBIx::Class'		=> 0.02;
requires	'DBIx::Class::Schema::Loader'	=>	0.03009;

auto_install;
WriteAl;

