#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use t::lib::Test     qw/connect_ok @CALL_FUNCS/;
use Test::More;

my @words = qw{
	berger Berg�re berg�re Bergere
	HOT h�te 
	h�t�roclite h�ta�re h�tre h�raut
	HAT h�ter 
	f�tu f�te f�ve ferme
     };
my @regexes = qw(  ^b\\w+ (?i:^b\\w+) );

BEGIN {
	if ($] < 5.008005) {
		plan skip_all => 'Unicode is not supported before 5.8.5';
	}
}
use Test::NoWarnings;

plan tests => 2 * (3 + 2 * @regexes) * @CALL_FUNCS + 1;

BEGIN {
	# Sadly perl for windows (and probably sqlite, too) may hang
	# if the system locale doesn't support european languages.
	# en-us should be a safe default. if it doesn't work, use 'C'.
	if ( $^O eq 'MSWin32') {
		use POSIX 'locale_h';
		setlocale(LC_COLLATE, 'en-us');
	}
}
use locale;

use DBD::SQLite;



foreach my $call_func (@CALL_FUNCS) {

  for my $use_unicode (0, 1) {

    # connect
    my $dbh = connect_ok( RaiseError => 1, sqlite_unicode => $use_unicode );

    # The following tests are about ordering, so don't reverse!
    if ($dbh->selectrow_array('PRAGMA reverse_unordered_selects')) {
      $dbh->do('PRAGMA reverse_unordered_selects = OFF');
    }

    # populate test data
    my @vals = @words;
    if ($use_unicode) {
      utf8::upgrade($_) foreach @vals;
    }

    $dbh->do( 'CREATE TEMP TABLE regexp_test ( txt )' );
    $dbh->do( "INSERT INTO regexp_test VALUES ( '$_' )" ) foreach @vals;

    foreach my $regex (@regexes) {
      my @perl_match     = grep {/$regex/} @vals;
      my $sql = "SELECT txt from regexp_test WHERE txt REGEXP '$regex' "
              .                             "COLLATE perllocale";
      my $db_match = $dbh->selectcol_arrayref($sql);

      is_deeply(\@perl_match, $db_match, "REGEXP '$regex'");

      my @perl_antimatch = grep {!/$regex/} @vals;
      $sql =~ s/REGEXP/NOT REGEXP/;
      my $db_antimatch = $dbh->selectcol_arrayref($sql);
      is_deeply(\@perl_antimatch, $db_antimatch, "NOT REGEXP '$regex'");
    }

    # null
    {
      my $sql = "SELECT txt from regexp_test WHERE txt REGEXP NULL "
              .                             "COLLATE perllocale";
      my $db_match = $dbh->selectcol_arrayref($sql);

      is_deeply([], $db_match, "REGEXP NULL");

      $sql =~ s/REGEXP/NOT REGEXP/;
      my $db_antimatch = $dbh->selectcol_arrayref($sql);
      is_deeply([], $db_antimatch, "NOT REGEXP NULL");
    }
  }
}

