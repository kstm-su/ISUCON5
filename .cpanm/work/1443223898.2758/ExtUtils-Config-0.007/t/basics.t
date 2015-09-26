#!/usr/bin/perl -w

use strict;
use warnings FATAL => 'all';
use Test::More 0.88;

use Config;

use ExtUtils::Config;

my $config = ExtUtils::Config->new;

ok($config->exists('path_sep'), "'path_sep' is set");
is($config->get('path_sep'), $Config{path_sep}, "'path_sep' is the same for \$Config");

ok(!$config->exists('nonexistent'), "'nonexistent' is still nonexistent");

ok(!defined $config->get('nonexistent'), "'nonexistent' is not defined");

is_deeply($config->all_config, \%Config, 'all_config is \%Config');

my $clone = $config->clone;

{
	my %myconfig = %Config;
	$config->set('more', 'nomore');
	$myconfig{more} = 'nomore';

	is_deeply($config->values_set, { more => 'nomore' }, 'values_set is { more => \'nomore\'}');
	is_deeply($clone->values_set, { }, 'values_set not is { more => \'nomore\'} in clone');

	is_deeply($config->all_config, \%myconfig, 'allconfig is myconfig');

	$config->clear('more');
}

is_deeply($config->all_config, \%Config, 'all_config is \%Config again');

my $set = $config->values_set;
$set->{more} = 'more3';
is($config->get('more'), $Config{more}, "more is still '$Config{more}'");

my $config2 = ExtUtils::Config->new({ more => 'more3' });

is_deeply($config2->values_set, { more => 'more3' }, "\$config2 has 'more' set to 'more3'");

done_testing;
