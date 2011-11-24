#!/usr/bin/perl

=head1 NAME

Net::NMap::Scan::Theme::Base - The base theme for all Net::Nmap::Scan::Themes

=head1 SYNOPSIS

  # You can base your own modules on this or others
  package Net::NMap::Scan::Theme::Foo;
  use Moose;

  extents 'Net::NMap::Scan::Theme::Base';

  @commands = ('-v','-sL','-p1-2000');

=head1 DESCRIPTION

The Base theme should be the primer of all forthcoming themes

=cut

package Net::NMap::Scan::Theme::Base;

our $VERSION = '';

use 5.010_000;

use strict;
use warnings;
use Moose;

=head1 ATTRIBUTES

Net::NMap::Scan::Theme::Base only defines a few base attributes you can change in your extended themes.

=head2 commands

This attribute holds the commands that should be appended to the commandline of nmap

By default no commands are set

=cut
has 'commands' => ( is => 'rw' , isa => 'ArrayRef[String]');

=head2 compat

Holds the compatibility information for this theme. Compatibility in this case
means wether or not the version of nmap is compatible with the commands you
choose to add here.

Default compat: 5.0

=cut
has 'compat' => ( is => 'rw' , isa => 'float' , default => '5.0');

=head2 needRoot

Some of the commands provided by nmap need root ($UID=0) permissions.
You can set this to true if your command list needs root access

=cut
has 'need_root' => ( is => 'rw' , isa => 'Bool', default => 0 );




no Moose;
1;
