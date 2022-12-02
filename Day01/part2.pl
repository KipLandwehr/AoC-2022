#!/usr/bin/perl
use warnings;
use strict;

my $mostCal = 0;
my $secondCal = 0;
my $thirdCal = 0;
my $currCal = 0;

while (<>) {
	chomp;
	if ( $_ =~ /^$/ ) {
		if ( $currCal > $mostCal ) {
			$thirdCal = $secondCal;
			$secondCal = $mostCal;
			$mostCal = $currCal
		}
		elsif ( $currCal > $secondCal ) {
			$thirdCal = $secondCal;
			$secondCal = $currCal;
		}
		elsif ( $currCal > $thirdCal ) {
			$thirdCal = $currCal;
		}
		$currCal = 0;
	}
	else {
		$currCal += $_;
	}
}

# Answer
my $answer = $mostCal + $secondCal + $thirdCal;

# Print solution
print "Solution: $answer\n";

