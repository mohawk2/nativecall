use ExtUtils::MakeMaker;
use strict;
use warnings;

WriteMakefile(
  NAME => 'NativeCall',
  VERSION_FROM => 'lib/NativeCall.pm',
  CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0 },
  ABSTRACT_FROM => 'lib/NativeCall.pm',
  AUTHOR => 'Ed J <etj@cpan.org>',
  LICENSE => 'perl',
  META_MERGE => {
    "meta-spec" => { version => 2 },
    resources => {
      repository => {
        type => 'git',
        url => 'git://github.com/mohawk2/nativecall',
        web => 'https://github.com/mohawk2/nativecall',
      },
    },
  },
);
