# install Module::Install Module::Install::AuthorTests Module::Install::ReadmeFromPod Module::Install::Repository
sub author_tests  { }
sub readme_from   { }
sub auto_set_repository { }

use inc::Module::Install;

name 'Stream-Buffered';
all_from 'lib/Stream/Buffered.pm';
readme_from 'lib/Stream/Buffered.pm';

tests 't/*.t';
author_tests 'xt';

auto_set_repository;

resources
  homepage      => "http://plackperl.org",
  bugtracker    => "https://github.com/plack/Plack/issues";

WriteAll;
