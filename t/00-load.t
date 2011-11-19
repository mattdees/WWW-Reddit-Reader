#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Reddit::Reader' ) || print "Bail out!\n";
}

diag( "Testing WWW::Reddit::Reader $WWW::Reddit::Reader::VERSION, Perl $], $^X" );
