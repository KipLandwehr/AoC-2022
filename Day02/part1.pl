#!/usr/bin/perl
use warnings;
use strict;

my $totalScore = 0;

while (<>) {
    chomp;
    my ($oppo, $self) = split (' ', $_);
    $totalScore += getShapePoints($self);
    $totalScore += getOutcomePoints($oppo, $self);
}

print "Answer: $totalScore\n";


# Notes
# A,X == Rock
# B,Y == Paper
# C,Z == Scissors

sub getShapePoints {
    my $shape = shift;
    return 1 if ($shape eq 'X');
    return 2 if ($shape eq 'Y');
    return 3 if ($shape eq 'Z');
}

sub getOutcomePoints {
    my $oppo = shift;
    my $self = shift;
    # Winning conditions
    return 6 if ($oppo eq 'A' and $self eq 'Y');
    return 6 if ($oppo eq 'B' and $self eq 'Z');
    return 6 if ($oppo eq 'C' and $self eq 'X');
    # Draw conditions
    return 3 if ($oppo eq 'A' and $self eq 'X');
    return 3 if ($oppo eq 'B' and $self eq 'Y');
    return 3 if ($oppo eq 'C' and $self eq 'Z');
    # Losing conditions
    return 0 if ($oppo eq 'A' and $self eq 'Z');
    return 0 if ($oppo eq 'B' and $self eq 'X');
    return 0 if ($oppo eq 'C' and $self eq 'Y');
}