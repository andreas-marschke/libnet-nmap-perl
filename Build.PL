# Build.PL for Module::Info::File

# $Id: Build.PL,v 1.15 2006/12/07 09:23:35 jbn Exp $

use strict;
use Module::Build;

my $build = Module::Build->new(
  dist_author       => 'Andreas Marschke, <andreas.marschke@gmail.com>',
  module_name       => 'Net::Nmap',
  dist_version      => '0.01',
  dist_abstract     => 'Net::Nmap a simple extensible wrapper around nmap',
  distribution_type => 'module',
  license           => 'perl',
  #  scripts => {
  #   'script/version.pl'   => 'script/version.pl',
  # },
  recursive_test_files => 1,
  requires => {
    'Carp'   => 0,
    'IPC::Run' => 0,
    'Module::Pluggable' => 0,
    'Moose' => 0,
    'Nagios::Object' => 0,
    'Net::DNS' => 0,
    'Net::DNS::Resolver' => 0,
    'XML::Twig' => 0
  },
  create_makefile_pl => 'traditional'
 );
$build->create_build_script();
