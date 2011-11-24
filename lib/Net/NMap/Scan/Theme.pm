#!/usr/bin/perl

=head1 NAME

  Net::Nmap::Scan::Theme  - Themes for scanning hosts

=head1 SYNOPSIS

  use Net::Nmap::Scan::Theme;
  my $object = Net::Nmap::Scan::Theme->new(...);

=head1 DESCRIPTION

Themes can be a simple array of commands that you'd like to append 
to nmap's commandline. They are basically modules that all extend 
Net::Nmap::Scan::Theme::Base which implements the simplest commands (-vvv,--


=cut

package Net::Nmap::Scan::Theme;

our $VERSION = '';

use 5.010_000;

use strict;
use warnings;
use Moose;
use Module::Pluggable search_path => ['Net::Nmap::Scan::Theme'];

=head1 get_theme

Returns array of Commands to be attached to nmap runs
You can use it like this:

 push @cmd,$theme->get_theme("Defensive");

This will pull the commands necessary for the defensive theme out of the
Net::Nmap::Scan::Theme::* namespace and push them onto the @cmd array.

=cut

sub get_theme {
  my $self = shift;
  my $theme_name = shift;
  my $theme = $self->only($theme_name);
  return $theme->commands() unless $theme->can('commands');
}

=head1 needs_root

Returns the value of C<need_root> from the theme. This way you can sort out the themes you want to include
and those you dont want to.

=cut
sub needs_root {
  my $self = shift;
  my $theme_name = shift;
  my $theme  = $self->only($theme_name);
  return $theme->need_root() unless $theme->can('need_root');
}

=head1 version_of

returns the version set by the theme.

=cut

sub compat {
  my $self = shift;
  my $theme_name = shift;
  my $theme = $self->only($theme_name);
  return $theme->compat() unless $theme->can('compat');
}

no Moose;
1;
