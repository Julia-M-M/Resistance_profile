#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use 5.010;

# Input file
my ( $dir, $DEBUG, $filename );
GetOptions(
	'f|file=s' => \$filename,
	'db|debug' => \$DEBUG
);
if ( !defined $filename ) {
	say "No filename passed.";
	exit;
}

open( my $fh, "<", $filename ) || die "Cannot open $filename";
