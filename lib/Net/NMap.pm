#!/usr/bin/perl

=head1 NAME

Net::NMap - A wrapper around nmap

=head1 SYNOPSIS

 use Net::NMap;

 my $object = Net::NMap->new( hosts => @Hosts,
                              ports => @ports,
                              isVerbose => 1,
                              scanTheme => "Defensive" );
 $object->run();
 my %hosts = $object->v4_Hosts();
 my $nagObj = $object->dump_to_nagios();

=head1 DESCRIPTION

=cut

package Net::NMap;

our $VERSION = '';

use 5.010_000;

use strict;
use warnings;
use Nagios::Object;
use IPC::Run;
use Moose;
use vars qw($VERSION);
use Net::Nmap::Scan;

=head1 Attributes

=cut

=head2 hosts

An array containing all hosts/ip addresses you might want to get scanned can be
an IP-Address an address-range or a domain-name.

B<NOTE:> to be safe against misuse this list will be altered to not include
invalid or malicious content

=cut

has 'hosts' => ( is => 'rw' , isa => 'ArrayRef[Str]', require => 1);


=head2 ports

An array of Ports or portranges you want to scan.

B<NOTE:> to be safe against misuse this list will be altered to not include
invalid or malicious content

=cut

has 'ports' => ( is => 'rw' , isa => 'ArrayRef[Str]');

=head2 theme

An array of Net::Nmap::Scan::Theme objects containing the scanning themes you
may want or do not want to combine.

If undef will default to Net::Nmap::Scan::Theme::Base.

=cut

has 'theme' => ( is => 'rw' , isa => 'ArrayRef[Str]' , default => undef);

=head1 run_scan

Runs a scan on @hosts,with the additional commands from the $theme.
If no theme was set it will use the Base theme.

=cut

=head1 Methods

=cut

=head2 run_scan

Executes nmap with the given commands defined by the list of hosts and themes.

=cut

sub run_scan {
  my $self = shift;
  
}
no Moose;
1;
