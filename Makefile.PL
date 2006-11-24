use inc::Module::Install;

name 'EventBot';
all_from 'lib/EventBot.pm';

requires	'Email::Simple'		=> 1.95;
requires	'Email::Send'		=> 2.17;
requires	'Mail::Address'		=> 1.67; # figure out correct one
requires	'DBIx::Class'		=> 0.07003;
requires	'DBIx::Class::Schema::Loader'	=>	0.03009;

auto_install;
WriteAll;

