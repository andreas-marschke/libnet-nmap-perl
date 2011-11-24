#!/usr/bin/perl

=head1 NAME

Net::Nmap::Scan - The actual execution of a scan

=head1 SYNOPSIS

 use Net::Nmap::Scan;

 my $object = Net::Nmap::Scan->new( themes => ['Defensive','Debug'], 
                                    hosts => ['www.google.com','192.168.0.1/24'],
                                    to_file => '/tmp/nmap.log');


=head1 DESCRIPTION

=cut

package Net::Nmap::Scan;

our $VERSION = '';

use 5.010_000;

use Carp qw(carp croak);
use IPC::Run qw(run);
use Moose;
use Net::IP;
use Net::DNS::Resolver;
use Net::DNS;
use Net::Nmap::Scan::Theme;

=head1 Attributes

=cut

=head2 nmap_bin

Path to the nmap binary as determined by C<get_nmap_bin>.

=cut
has 'nmap_bin' => ( is => 'ro' , isa => 'Str');


=head2 cmd

The accumulated commandline executed through IPC::Run.

=cut
has 'cmd' => ( is => 'ro' , isa => 'ArrayRef[Str]');

=head2 hosts

An arrayref of hosts.
NOTE: This will change in the course of executing C<run_scan> since C<run_scan>
uses C<validate_host> to check wether or not the hosts in @hosts are valid or not.
Default value is ['localhost']

=cut
has 'hosts' => ( is => 'rw' , isa => 'ArrayRef[Str]', default => sub {['localhost']});

=head2 themes

We store the chosen themes in an arrayref to use more than one theme at a time.

=cut
has 'themes' => (is => 'rw', isa => 'ArrayRef[Str]', default => sub{['Base']});

=head2 version

Holds the version of nmap(1) as a float for comparison agains the version set
in the themes.

=cut
has 'version' => ( is => 'rw' , isa => 'Num');

=head2 to_file

If empty will print the XML output of the scan to its pseudo STDOUT and be parsed from there.
If a valid string to a nonexisting file will print for debugging into this file.

Can be used for debugging/logging purposes.

=cut
has 'to_file' => ( is => 'rw' , isa => 'Str', default => undef);

=head1 Methods

=cut

=head2 BUILD

Sets the version and path of nmap available on this machine.

=cut
sub BUILD {
  my $self = shift;
  croak 'There is no nmap binary on this machine!' unless defined $self->get_nmap_bin();
  $self->version($self->get_nmap_version());
}

=head2 run_scan

Runs the scan in an IPC::Run instance and validates the hosts and adds up the 
command options one wants to execute.

returns either the xml-output of the scan to STDIN or the path to the file it wrote the xml to.

=cut
sub run_scan {
  my $self = shift;
  my $theme = Net::Nmap::Scan::Theme->new();

  push @{$self->cmd},$self->nmap_bin();
  $self->hosts = $self->validate_hosts($self->hosts);

  # push themes onto the command stack
  if ($ENV{UID} eq 0) {
    foreach ($self->themes) {
      if ($theme->compat($_) >= $self->version) {
	push @{$self->cmd},$theme->get_theme($_);
      }
    }
  } else {
    foreach ($self->themes) {
      if ($theme->compat($_) >= $self->version) {
	push @{$self->cmd},$theme->get_theme($_) if (!$theme->need_root($_));
      }
    }
  }
  push @{$self->cmd},$self->hosts;
  my ( $in, $out, $err ) = "";
  if (defined $self->to_file) {
    push @{$self->cmd},('-oX',$self->to_file);
  } else {
    push @{$self->cmd},('-oX',"-");
  }
  run (\$self->cmd, \$in, \$out, \$err);
  return defined $self->to_file ? $self->to_file : $out;
}

=head1 validate_hosts

Checks if the given hosts are actual hosts or should be removed from the list of 
hosts.

Removes invalid hosts from the list of hosts and returns only valid hosts.

=cut

sub validate_hosts {
  my $self = shift;
  my @hosts;
  my $res = Net::DNS::Resolver->new;
  foreach my $host ($self->hosts) {
    if (! new Net::IP($host) ) {
      if (!$res->search('$host')) {
	  $self->hosts(grep (!/^($host)$/, $self->hosts));
      }
    }
  }
}

=head1 get_nmap_version

Gets the installed version of nmap and sets it in $self->version;

=cut

sub get_nmap_version {
  my $self = shift;
  my @cmd = qw(nmap --version);
  my ( $in, $out, $err ) = "";
  run (\@cmd, \$in, \$out, \$err);
  if ($out =~ m/version\s([0-9.]*)/) {
    return $1;
  }
}

=head1 get_nmap_bin

Run which(1) to search for the nmap executable in your $PATH.
Returns undef if no nmap binary was found

=cut

sub get_nmap_bin {
  my $self = shift;
  my @cmd = qw(which nmap);
  my ( $in, $out, $err ) = "";
  run (\@cmd, \$in, \$out, \$err);
  chomp $out;
  if ($out =~ m/^$/) {
    return undef;
  } else {
    return $out;
  }
}

no Moose;
1;
