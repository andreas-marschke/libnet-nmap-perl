#!/usr/bin/perl -w

use Test::More tests => 2 ;
use Net::Nmap::Scan;

BEGIN { use_ok( 'Net::Nmap::Scan' ); }
require_ok( 'Net::Nmap::Scan' );
