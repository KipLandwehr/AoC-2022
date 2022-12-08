#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper qw(Dumper);

# Read input into a 2D array
# input[row][col]
my @input;
my $lineno = 0;
while (<>) {
    chomp;
    @{$input[$lineno]} = split(//, $_);
    ++$lineno;
}

my $gridWidth = @{$input[0]};
my $gridHeight = @input;

my $answer = 0;

for (my $row = 0; $row < $gridHeight; $row++) {
    for (my $col = 0; $col < $gridWidth; $col++) {
        ++$answer if (canBeSeen($row,$col));
    }
}

print "Answer: $answer\n";

sub canBeSeen {
    my $row = shift;
    my $col = shift;

    return 1 if (checkRow($row, $col) or checkCol($row, $col));
    #else
    return 0;
}

sub checkRow {
    my $row = shift;
    my $col = shift;

    # Can be seen if on the edge
    return 1 if ($row == 0 or $row == ($gridHeight-1));

    # Start out assuming we can be seen from both East and West
    my $east = 1;
    my $west = 1;

    # Check if anything to our west is taller or same height
    for (my $i = 0; $i < $col; ++$i) {
        $west = 0 if ($input[$row][$i] >= $input[$row][$col]);
    }
    # Check if anything to our east is taller or same height
    for (my $i = ($gridWidth-1); $i > $col; --$i) {
        $east = 0 if ($input[$row][$i] >= $input[$row][$col]);
    }
    # If we can be seen from eith E or W, then we can be seen
    return 1 if ($east or $west);
    # Else, we can't be seen from either E or W
    return 0;
}

sub checkCol {
    my $row = shift;
    my $col = shift;

    # Can be seen if on the edge
    return 1 if ($col == 0 or $col == ($gridWidth-1));

    # Start out assuming we can be seen from both North and South
    my $north = 1;
    my $south = 1;

    # Check if anything to our North is taller or same height
    for (my $i = 0; $i < $row; ++$i) {
        $north = 0 if ($input[$i][$col] >= $input[$row][$col]);
    }
    # Check if anything to our South is taller or same height
    for (my $i = ($gridHeight-1); $i > $row; --$i) {
        $south = 0 if ($input[$i][$col] >= $input[$row][$col]);
    }
    # If we can be seen from eith N or S, then we can be seen
    return 1 if ($north or $south);
    # Else, we can't be seen from either N or S
    return 0;
}