#!/usr/bin/perl

use lib 'lib';

use WWW::Reddit::Reader ();
use Data::Dumper;

my $reader = WWW::Reddit::Reader->new('EarthPorn');
$reader->read('top', 'month');
print Dumper $reader->get_result();