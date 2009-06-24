use inc::Module::Install;

name 'EventBot';
all_from 'lib/EventBot.pm';

requires 'Class::Accessor';
requires    'File::HomeDir';
requires    'File::Spec';
requires    'Email::Simple' => 2.01;
requires    'Email::MIME';
requires    'Email::Simple::Creator' => 1.423;
requires    'Email::Send'  => 2.17;
requires    'MIME::Lite' => 3;
requires    'Mail::Address'     => 1.67; # figure out correct one
requires    'DBIx::Class'       => 0.08013;
requires    'File::Slurp';
requires 'Catalyst' => '5.7100';
requires 'Catalyst::View::TT';
requires 'Catalyst::Model::DBIC::Schema';
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
