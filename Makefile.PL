use inc::Module::Install;

name 'EventBot';
all_from 'lib/EventBot.pm';

requires    'File::HomeDir';
requires    'File::Spec';
requires    'Email::Simple'     => 1.95;
requires    'Email::Simple::Creator' => 1.423;
requires    'Email::Send'       => 2.17;
requires    'Mail::Address'     => 1.67; # figure out correct one
requires    'DBIx::Class'       => 0.07003;
requires    'File::Slurp';
requires 'Catalyst' => '5.7006';
requires 'Catalyst::View::TT';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'XML::RSS';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
