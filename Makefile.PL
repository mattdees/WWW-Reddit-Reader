use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Reddit::Reader',
    AUTHOR              => q{Matt Dees <matt@lessthan3.net>},
    VERSION_FROM        => 'lib/WWW/Reddit/Reader.pm',
    ABSTRACT_FROM       => 'lib/WWW/Reddit/Reader.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Reddit-Reader-*' },
);
