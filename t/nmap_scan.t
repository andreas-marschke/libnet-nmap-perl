#!/usr/bin/perl -w

use Test::More tests => 6 ;
use Net::Nmap::Scan;

BEGIN { use_ok( 'Net::Nmap::Scan' ); }
require_ok( 'Net::Nmap::Scan' );

# test if get_nmap_bin returns undef if which doesnt return anything
BEGIN{
  $ENV{PATH}="/usr/bin:/bin/"; # search in default dirs
  isnt(Net::Nmap::Scan::get_nmap_bin(),undef,'test if nmap_bin is undef if not in PATH');
}

BEGIN{
  my $nmap = Net::Nmap::Scan->new();
  like($nmap->get_nmap_version(),'m/[0-9.]*/','Test if version string is valid');
}

BEGIN { 
  my @test_array = qw(localhost www.google.com 127.0.0.1);
  my $nmap = Net::Nmap::Scan->new(hosts => \@test_array );
  $nmap->validate_hosts();
  is(@{$nmap->hosts},@test_array,'Test if valid hosts are kept in array');
}

BEGIN { 
  my @test_array_valid = qw(localhost www.google.com 127.0.0.1);
  my @test_array_invalid = qw(localhost www.g!gle.com 127.0.0.1);
  my $nmap = Net::Nmap::Scan->new(hosts => \@test_array_invalid);
  $nmap->validate_hosts();
  is_deeply($nmap->hosts,\@test_array_valid,'Test if in-valid hosts are kept in array');
}
