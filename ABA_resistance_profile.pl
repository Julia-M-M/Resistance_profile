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
say "id\tresistance_profile\tantib_panel_count";
while ( my $line = <$fh> ) {
	next if !$line;    #Ignore empty lines.
	next
	  if $line =~ /^\D/
	  ; #Ignore lines that start with a non numeric character (like the header).

	chomp $line;    #Remove the \n character if there is one (before spliting)

	# Result
	my (
		$id,               $amikacin_SIR, $gentamicin_SIR,
		$cefotaxime_SIR,   $cefepime_SIR, $levofloxacin_SIR,
		$tetracycline_SIR, $imipenem_SIR, $meropenem_SIR,
		$colistin_SIR
	) = split /\t/, $line;
	my $resistance_profile = resistance_profile_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);
	my $antib_panel_count = antib_panel_count_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);

	# Output
	say "$id\t$resistance_profile\t$antib_panel_count";
#	last;    #Only run first line
}

##SUBROUTINES##
# Antibiotic panel count
sub antib_panel_count_formula {

#		use Data::Dumper; say Dumper @_;
	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;
	my $antib_panel_count = 0;

	if ( $amikacin_SIR ne '' ) {    #if it is not an empty string
		$antib_panel_count ++;	#increment by one (+= 1) --> -- for decrementing by one
	}
	if ( $gentamicin_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $cefotaxime_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $cefepime_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $levofloxacin_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $tetracycline_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $imipenem_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $meropenem_SIR ne '' ) {
		$antib_panel_count ++;
	}
	if ( $colistin_SIR ne '' ) {
		$antib_panel_count ++;
	}
	return $antib_panel_count;
}

# Count resistance (R/I)
sub antib_RI_formula {
	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;

	my $RI_count = 0;
	my %allowed  = ( 'R' => 1, 'I' => 1 );
	if ( $allowed{$amikacin_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$gentamicin_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$cefotaxime_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$cefepime_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$levofloxacin_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$tetracycline_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$imipenem_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$meropenem_SIR} ) {
		$RI_count ++;
	}
	if ( $allowed{$colistin_SIR} ) {
		$RI_count ++;
	}

	return $RI_count;
}

# Count sensitive (S)
sub antib_S_formula {
	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;
	my $S_count = 0;
	my %allowed = ( 'S' => 1 );
	if ( $allowed{$amikacin_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$gentamicin_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$cefotaxime_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$cefepime_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$levofloxacin_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$tetracycline_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$imipenem_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$meropenem_SIR} ) {
		$S_count ++;
	}
	if ( $allowed{$colistin_SIR} ) {
		$S_count ++;
	}
	return $S_count;
}

# Antibiotic family count
sub family_count_formula {
	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;
	my $family_count = 0;

	#	my %allowed = ('S' => 1, 'I' => 1, 'R' => 1);
	my %allowed = map { $_ => 1 } qw(S I R);

#	my %allowed = map {$_ => 1} ('S' 'I' 'R');
#	if (($amikacin_SIR eq 'S' or $amikacin_SIR eq 'I' or $amikacin_SIR eq 'R') || ($gentamicin_SIR eq 'S' or $gentamicin_SIR eq 'I' or $gentamicin_SIR eq 'R')){
	if ( $allowed{$amikacin_SIR} or $allowed{$gentamicin_SIR} ) {

#WRONG	if ( $amikacin_SIR eq ("R" or "I" or "S") || $gentamicin_SIR eq ("R" or "I" or "S") ) {
		$family_count ++;
	}
	if ( $allowed{$cefotaxime_SIR} or $allowed{$cefepime_SIR} ) {
		$family_count ++;
	}
	if ( $allowed{$levofloxacin_SIR} or $allowed{$tetracycline_SIR} ) {
		$family_count ++;
	}
	if ( $allowed{$imipenem_SIR} or $allowed{$meropenem_SIR} ) {
		$family_count ++;
	}
	if ( $allowed{$colistin_SIR} ) {
		$family_count ++;
	}
	return $family_count;
}

# Count resistant families (R/I)
sub antib_RIfam_formula {
	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;
	my $RIfam_count = 0;
	my %allowed     = ( 'R' => 1, 'I' => 1 );
	if ( $allowed{$amikacin_SIR} or $allowed{$gentamicin_SIR} ) {
		$RIfam_count ++;
	}
	if ( $allowed{$cefotaxime_SIR} or $allowed{$cefepime_SIR} ) {
		$RIfam_count ++;
	}
	if ( $allowed{$levofloxacin_SIR} or $allowed{$tetracycline_SIR} ) {
		$RIfam_count ++;
	}
	if ( $allowed{$imipenem_SIR} or $allowed{$meropenem_SIR} ) {
		$RIfam_count ++;
	}
	if ( $allowed{$colistin_SIR} ) {
		$RIfam_count ++;
	}
	return $RIfam_count;
}

# Resistance profile conditions
sub resistance_profile_formula {

	my (
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	) = @_;
	my $antib_panel_count = antib_panel_count_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);
	my $family_count = family_count_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);
	my $RI_count = antib_RI_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);
	my $S_count = antib_S_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);
	my $RIfam_count = antib_RIfam_formula(
		$amikacin_SIR, $gentamicin_SIR,   $cefotaxime_SIR,
		$cefepime_SIR, $levofloxacin_SIR, $tetracycline_SIR,
		$imipenem_SIR, $meropenem_SIR,    $colistin_SIR
	);

	my $SIR_count = $RI_count + $S_count;
	if ( $antib_panel_count != $SIR_count ) {
		return
"Error: antib_panel_count ($antib_panel_count) different from SIR_count ($S_count+$RI_count = $SIR_count)";
	}
	if ( $antib_panel_count == 0 ) {
		return
"Error: No antibiotic panel";
	}
	
	if ( $antib_panel_count != 0 ) {

		if ( $RI_count == $antib_panel_count && $S_count == 0 ) {	#PDR: non-susceptible to all antimicrobial agents listed
			return "PDR";
		}

		if ( $RI_count == 0 && $S_count == $antib_panel_count ) {	#S: susceptible to all antimicrobial agents listed
			return "sensitive";
		}

		if ( $family_count - $RIfam_count <= 2 ) {	#XDR: non-susceptible to >=1 agent in all but <=2 categories
			return "XDR";
		}
		if ( $family_count - $RIfam_count <= 2 ) {
			return "XDR*";
		}

		if ( $RIfam_count >= 3 ) {	#MDR: non-susceptible to >=1 agent in >=3 antimicrobial categories.
			return "MDR";
		}
		if ( $RIfam_count >= 3 ) {	
			return "MDR*";
		}
		if ( $RIfam_count < 3 && $RI_count != 0) {
			return "not MDR";
		}
		if ( $RIfam_count < 3 && $RI_count != 0) {
			return "not MDR*";
		}
		
		else {
		return "Error: unclassified";
		}
	}
	else {
		return "Error $!";
	}
}
