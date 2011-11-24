#!/usr/bin/perl

=head1 NAME

Net::NMap::Scan::Theme::Defensive - A "Defensive" theme for Net::NMap

=head1 SYNOPSIS

  my $theme = Net::NMap::Scan::Theme->new();
  push @cmd,$theme->get_theme("Defensive");

=head1 DESCRIPTION

It will only make a ping scan and will not use any advanced
methods on the hosts you plan to scan.

=cut

package Net::NMap::Scan::Theme::Defensive;

our $VERSION = '0.001';

use 5.010_000;

use Moose;
extents 'Net::NMap::Scan::Theme::Base';

sub BUILD {
  my $self = shift;
  $self->commands = ('-v',		# be verbose
		     '-sP',		# only do Pingscans
		     '--traceroute');   # do a traceroute
  $self->compat = 5.0;
  $self->need_root = 0;
}


no Moose;
1;
