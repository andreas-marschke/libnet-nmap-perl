#!/usr/bin/perl

=head1 NAME

Net::Nmap::XML - An XML parser for Nmap's XML-Output

=head1 SYNOPSIS

 use Net::Nmap::XML;

 # initialize it and use the plugins
 my $object = Net::Nmap::XML->new(plugin => qw(banner));
 $object->parse_file('parseable.xml');
 # OR
 $object->parse($xml_output);

 # If you want to use the config in scan it can export it to Nagios::Object
 my $nagobj = $object->dump_nagios_object();
 print $nagobj->dump();

 # If that ain't fancy enough Net::Nmap::Host:
 print $object->dump_nmap_host();

=head1 DESCRIPTION



=cut

package Net::Nmap::XML;

our $VERSION = '';

use 5.010_000;

use strict;
use warnings;
use Moose;
use XML::Twig;
use Nagios::Object;

=head1 Attributes

=cut

=head2 plugin

Additional parsing plugins that can dump to new features.
These will parse things like the results of activating banner.nse scans or
finger.nse.

=cut

has 'plugin' => ( is => 'rw' , isa => 'ArrayRef[Str]', require => 0);

=head2 content

For testing and debugging you can dump out the content of the file or
string that was parsed by Net::Nmap::XML.

=cut

has 'content' => ( is => 'r' , isa => 'Str');


=head2 parse_file($filepath)

Parses file output xml file of nmap
It returns undef if parsing wasn't successfull.

=cut

sub parse_file {
  my $self = shift;
  my $file = shift;

  $self->content = read_file( $file );
  return undef if (!defined $self->content );

  my $twig = XML::Twig->new();
  $twig->parse($self->content);
  

}

=head2 parse($content)

Parses content of the scalar($content) for the xml data.

=cut
sub parse {
  my $self = shift;
}


no Moose;
1;
