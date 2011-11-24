#!/usr/bin/perl

=head1 NAME

Net::Nmap::Scan::Theme::Aggressive - An "Aggressive" theme for Net::Nmap

=head1 SYNOPSIS

  my $theme = Net::Nmap::Scan::Theme->new();
  push @cmd,$theme->get_theme("Aggressive");

=head1 DESCRIPTION

It will press the hosts for answers and send spoofed packets in order to force
an answer by the host

=cut

package Net::Nmap::Scan::Theme::Defensive;

our $VERSION = '0.001';

use 5.010_000;

use Moose;
extents 'Net::Nmap::Scan::Theme::Base';

sub BUILD {
  my $self = shift;
  $self->commands = ('-v',	      # be verbose
		     '-sX',	      # only do Pingscans
		     '--osscan-guess',
		     '--max-rtt-timeout', '1',
		     '-T4',
		     '--packet-trace',
		     '-PN',
		     '-sL'); # do a traceroute
  $self->compat = 5.0;
  $self->need_root = 1;
}


no Moose;
1;
