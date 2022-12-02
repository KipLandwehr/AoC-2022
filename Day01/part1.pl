#!/usr/bin/perl
use warnings;
use strict;

my $mostCal = 0;
my $currCal = 0;

while (<>) {
	chomp;
	if ( $_ =~ /^$/ ) {
		$mostCal = $currCal if ( $currCal > $mostCal );
		$currCal = 0;
	}
	else {
		$currCal += $_;
	}
}

# Print solution
print "Solution: $mostCal\n";

