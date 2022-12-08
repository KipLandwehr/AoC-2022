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
        my $score = getScore($row, $col);
        $answer = $score if ($score > $answer);
    }
}

print "Answer: $answer\n";

sub getScore {
    my $row = shift;
    my $col = shift;

    return (getRowScore($row, $col) * getColScore($row, $col));
}

sub getRowScore {
    my $row = shift;
    my $col = shift;

    # Score is 0 if on the edge
    return 0 if ($row == 0 or $row == ($gridHeight-1));

    my $east = 0;
    my $west = 0;

    # Get West score
    for (my $i = $col-1; $i >= 0; --$i) {
        ++$west;
        last if ($input[$row][$i] >= $input[$row][$col]);
    }
    # Get East score
    for (my $i = $col+1; $i < $gridWidth; ++$i) {
        ++$east;
        last if ($input[$row][$i] >= $input[$row][$col]);
    }
    return ($east * $west);
}

sub getColScore {
    my $row = shift;
    my $col = shift;

    # Score is 0 if on the edge
    return 0 if ($col == 0 or $col == ($gridWidth-1));

    my $north = 0;
    my $south = 0;

    # Get North score
    for (my $i = $row-1; $i >= 0; --$i) {
        ++$north;
        last if ($input[$i][$col] >= $input[$row][$col]);
    }
    # Get South score
    for (my $i = $row+1; $i < $gridHeight; ++$i) {
        ++$south;
        last if ($input[$i][$col] >= $input[$row][$col]);
    }
    return ($north * $south);
}