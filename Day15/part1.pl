#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

# test row
#my $row = 10;

# real row
my $row = 2000000;

my %answerRow;

while (<>) {
    chomp;
    warn "Input line $.\n" if ($debug > 0);
    # Example input line: Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    if ($_ =~ /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/) {
        my ($sx, $sy, $bx, $by) = ($1, $2, $3, $4);

        $answerRow{$sx} = 'S' if ($sy == $row);
        $answerRow{$bx} = 'B' if ($by == $row);
        
        # calculate x and y deltas between sensor and beacon
        my $dx = abs($sx-$bx);
        my $dy = abs($sy-$by);

        my $dist = $dx+$dy;

        if (($sy <= $row && $row <= $sy+$dist) || ($sy-$dist <= $row && $row <= $sy)) {
            warn "Sensor ($sx,$sy), Beacon ($bx,$by)\n" if ($debug > 1);
            my $ydist = abs($row-$sy);
            my $xdist = $dist-$ydist;
            my $minX = $sx-$xdist;
            my $maxX = $sx+$xdist;

            foreach my $val ($minX..$maxX) {
                warn "Adding value $val to row $row\n" if ($debug > 2);
                $answerRow{$val} = '#' if (not defined $answerRow{$val});
            }
        }
    }
}

if ($debug > 3) {
    foreach my $k (sort {$a <=> $b} keys %answerRow) {
        print "$k => $answerRow{$k}\n";
    }
}

my $answer;
foreach my $k (keys %answerRow) {
    ++$answer if ($answerRow{$k} eq 'S' || $answerRow{$k} eq '#');
}

print "Answer: $answer\n";