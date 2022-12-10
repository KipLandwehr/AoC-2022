#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my $firstCycle = 20;
my $cycleStep = 40;
my $maxCycle = 220;

my $answer;

my $x = 1;
my $cycle = 0;
my $nextCycle = $firstCycle;

while (<>) {
    chomp;
    ++$cycle;
    my $num;
    if ($_ =~ /^addx (-?\d+)$/) {
        $num = $1;
        ++$cycle;
    }
    if ($cycle >= $nextCycle) {
        warn "Cycle $nextCycle: Signal Strength = ", $x*$nextCycle, "\n" if $debug > 1;
        $answer += ($x * $nextCycle);
        $nextCycle += $cycleStep;
    }

    last if ($cycle >= $maxCycle);

    $x += $num if (defined $num);
}

print "Answer: $answer\n";