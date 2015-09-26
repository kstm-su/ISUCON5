
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "HTTP Body Parser",
  "AUTHOR" => "Christian Hansen, C<chansen\@cpan.org>, Sebastian Riedel, C<sri\@cpan.org>, Andy Grundman, C<andy\@hybridized.org>, Torsten Raudssus, C<getty\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Test::Deep" => 0,
    "Test::More" => "0.86"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "HTTP-Body",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "HTTP::Body",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Digest::MD5" => 0,
    "File::Temp" => "0.14",
    "HTTP::Headers" => 0,
    "IO::File" => "1.14"
  },
  "VERSION" => "1.17",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



