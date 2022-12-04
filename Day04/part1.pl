#!/usr/bin/perl
use warnings;
use strict;

my $answer = 0;

while (<>) {
    my ($range1,$range2) = split(',', $_);
    my ($r1min,$r1max) = split('-', $range1);
    my ($r2min,$r2max) = split('-', $range2);

    if (($r1min >= $r2min) and ($r1max <= $r2max)) {
        ++$answer;
    }
    elsif (($r2min >= $r1min) and ($r2max <= $r1max)) {
        ++$answer;
    }
}

print "Answer: $answer\n";