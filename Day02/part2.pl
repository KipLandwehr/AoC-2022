#!/usr/bin/perl
use warnings;
use strict;

my $totalScore = 0;

while (<>) {
    chomp;
    my ($oppo, $self) = split (' ', $_);
    $totalScore += getOutcomePoints($self);
    $totalScore += getShapePoints($oppo, $self);
}

print "Answer: $totalScore\n";


# Notes
# A == Rock
# B == Paper
# C == Scissors

# X == Lose
# Y == Draw
# Z == Win

sub getOutcomePoints {
    my $shape = shift;
    return 0 if ($shape eq 'X');
    return 3 if ($shape eq 'Y');
    return 6 if ($shape eq 'Z');
}

sub getShapePoints {
    my $oppo = shift;
    my $self = shift;
    # Winning conditions
    return 2 if ($oppo eq 'A' and $self eq 'Z');
    return 3 if ($oppo eq 'B' and $self eq 'Z');
    return 1 if ($oppo eq 'C' and $self eq 'Z');
    # Draw conditions
    return 1 if ($oppo eq 'A' and $self eq 'Y');
    return 2 if ($oppo eq 'B' and $self eq 'Y');
    return 3 if ($oppo eq 'C' and $self eq 'Y');
    # Losing conditions
    return 3 if ($oppo eq 'A' and $self eq 'X');
    return 1 if ($oppo eq 'B' and $self eq 'X');
    return 2 if ($oppo eq 'C' and $self eq 'X');
}