#!/usr/bin/perl
use warnings;
use strict;
use Data::Dump qw(dump);

my @input;

$/ = "\n\n";
while (<>) {
    my ($l1, $l2) = split "\n";
    my @arr1 = eval $l1;
    my @arr2 = eval $l2;
    push @input, (eval $l1, eval $l2)
}

# create array refs for our divider packets
my $div1 = [[2]];
my $div2 = [[6]];
# push the array refs for the divider packets onto input
push @input, ($div1, $div2);

#dump @input;

# sort our input
my @sorted = sort byRules @input;

#dump @sorted;

my $answer = 1;
for my $index (0..@sorted-1) {
    if ($sorted[$index] == $div1 || $sorted[$index] == $div2) {
        $answer *= ($index+1);
    }
}
print "Answer: $answer\n";


sub byRules {
    my $val = &checkOrder($a, $b);
    # remap return values of checkOrder to what sort needs
    # I'd have built checkOrder with these natively if I'd know about sort subroutines before starting part2
    if ($val == 0) {return 1;}
    elsif ($val == 1) {return -1;}
    else {return 0;}
}

# returns 0 if out of order
# returns 1 if in order
# returns 2 if "equal"
# A return of 2 happens if the arrays passed in both have length 0
sub checkOrder {
    my $aref1 = shift;
    my $aref2 = shift;

    #print "comparing the following arrays\n";
    #dump @$aref1;
    #dump @$aref2;

    # while index < length of both arrays
    my $i = 0;
    for ( ; $i < @$aref1 && $i < @$aref2 ; ++$i) {
        my $e1 = $$aref1[$i];
        my $e2 = $$aref2[$i];        

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

    if (@$aref1 == $i && @$aref2 == $i) {
        return 2;
    }
    elsif (@$aref1 == $i) {
        return 1;
    }
    else {  # @$aref2 == $i
        return 0;
    }
}