#!/usr/bin/perl
use warnings;
use strict;

my $answer;

$/ = "\n\n";
while (<>) {
    my ($l1, $l2) = split "\n";
    my @arr1 = eval $l1;
    my @arr2 = eval $l2;

    # I'm making the bold assumption that no ties (identical lines of input) exist.
    # Therefore, this call to checkOrder will only ever return either -
    # 0 : out of order
    # 1 : in order
    $answer += $. if (&checkOrder(\@arr1, \@arr2));
}

print "Answer: $answer\n";


# returns 0 if out of order
# returns 1 if in order
# returns 2 if "equal"
# A return of 2 happens if the arrays passed in both have length 0
sub checkOrder {
    my $aref1 = shift;
    my $aref2 = shift;

    # while both arrays are not empty
    while (@$aref1 && @$aref2) {
        my $e1 = shift @$aref1;
        my $e2 = shift @$aref2;

        if (ref($e1) eq "" && ref($e2) eq "") {
            if ($e1 < $e2) {return 1;}
            elsif ($e1 > $e2) {return 0;}
            else {next;}
        }
        elsif (ref($e1) eq "" && ref($e2) eq "ARRAY") {
            my $val = &checkOrder([$e1], $e2);
            if ($val == 0) {return 0;}
            elsif ($val == 1) {return 1;}
            else {next;}

        }
        elsif (ref($e1) eq "ARRAY" && ref($e2) eq "") {
            my $val = &checkOrder($e1, [$e2]);
            if ($val == 0) {return 0;}
            elsif ($val == 1) {return 1;}
            else {next;}

        }
        else {  # both are array refs
            my $val = &checkOrder($e1, $e2);
            if ($val == 0) {return 0;}
            elsif ($val == 1) {return 1;}
            else {next;}
        }
    }

    if (@$aref1 == 0 && @$aref2 == 0) {
        return 2;
    }
    elsif (@$aref1 == 0) {
        return 1;
    }
    else {  # @$aref2 empty
        return 0;
    }
}