# vim: sw=4 sts=4 et tw=75 wm=5
use inc::Module::Install;

name 'EventBot';
all_from 'lib/EventBot.pm';

requires 'Config::General';
requires 'Class::Accessor';
requires    'File::HomeDir';
requires    'File::Spec';
requires    'Email::Simple' => 2.005;
requires    'Email::MIME';
requires    'Email::Simple::Creator' => 1.423;
requires    'Email::Send'  => 2.17;
requires    'MIME::Lite' => 3;
requires    'Mail::Address'     => 1.67; # figure out correct one
requires    'DBIx::Class'       => 0.08107;
requires    'SQL::Translator'   => 0.09007;
requires    'File::Slurp';
requires 'DateTime::Format::Pg';
requires 'Catalyst' => '5.7100';
requires 'Catalyst::View::TT';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Controller::reCAPTCHA';
requires 'HTML::FormHandler' => '0.32000';
requires 'HTML::FormHandler::Model::DBIC' => '0.12000';
requires 'URI::Escape';

requires 'XML::RSS';
requires 'JSON::XS'; # Used for API calls
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');

WriteAll;
