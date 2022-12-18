#!/usr/bin/perl
use warnings;
use strict;
use Data::Dump qw(dump);

my $debug = 1;

my $minCoord = 0;
# test input
#my $maxCoord = 20;
# real input
my $maxCoord = 4000000;

my @field;

while (<>) {
    chomp;
    warn "Input line $.\n" if ($debug > 0);
    # Example input line: Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    if ($_ =~ /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/) {
        my ($sx, $sy, $bx, $by) = ($1, $2, $3, $4);
        
        # calculate x and y deltas between sensor and beacon
        my $dx = abs($sx-$bx);
        my $dy = abs($sy-$by);

        my $dist = $dx+$dy;

        my $minY = $sy - $dist;
        my $maxY = $sy + $dist;

        if ($debug > 1) {
            warn "Sensor ($sx,$sy), Beacon ($bx,$by)\n";
            warn "dist: $dist, minY: $minY, maxY: $maxY\n";
            warn "minCoord: $minCoord, maxCoord: $maxCoord\n";
        }

        next if ($minY > $maxCoord || $maxY < $minCoord);

        $minY = $minCoord if ($minY < $minCoord);
        $maxY = $maxCoord if ($maxY > $maxCoord);

        ROW: foreach my $row ($minY..$maxY) {
            my $ydist = abs($row-$sy);
            my $xdist = $dist-$ydist;

            my $minX = $sx - $xdist;
            my $maxX = $sx + $xdist;

            if ($debug > 2) {
                warn "  Row $row\n";
                warn "  minX: $minX, maxX: $maxX\n";
                warn "  minCoord: $minCoord, maxCoord: $maxCoord\n";
            }

            next if ($minX > $maxCoord || $maxX < $minCoord);

            $minX = $minCoord if ($minX < $minCoord);
            $maxX = $maxCoord if ($maxX > $maxCoord);

            if ( not defined $field[$row] ) {
                if ($debug > 2) {
                    warn "  Row $row was not yet defined in \@field\n";
                    warn "  Creating it now, with [$minX, $maxX]\n";
                }
                $field[$row] = [[$minX, $maxX]];
            }
            else {
                if ($debug > 2) {
                    print STDERR "  Starting row: ", dump(@{$field[$row]}), "\n";
                    warn "  Adding range of [$minX, $maxX]\n";
                }
                my $tmp = [];
                while (@{$field[$row]}) {
                    my $rangeRef = shift @{$field[$row]};
                    my ($rmin, $rmax) = ($$rangeRef[0],$$rangeRef[1]);

                    # range being added is lower than range being compared to
                    if ($maxX < $rmin) {
                        # check if they're "touching" ...
                        if ($maxX + 1 == $rmin) {
                            # Go ahead an union them
                            push @$tmp, [$minX, $rmax];
                        }
                        else {
                            # push the set being added, because it's lower than everything else
                            push @$tmp, [$minX, $maxX];
                            # keep the set being compared to
                            push @$tmp, $rangeRef;
                        }
                        # don't want to lose the rest of this row
                        push @$tmp, @{$field[$row]};
                        # we're donw with this row
                        last;
                    }
                    # range being added overlaps range being compared to on low side only
                    elsif ($minX < $rmin && ($rmin <= $maxX && $maxX <= $rmax)) {
                        # push the union of the two ranges
                        push @$tmp, [$minX, $rmax];
                        # don't lose the rest of the row
                        push @$tmp, @{$field[$row]};
                        # we're donw with this row
                        last;
                    }
                    # range being added completely contains range being compared to
                    elsif ($minX <= $rmin && $rmax <= $maxX) {
                        if (@{$field[$row]}) {
                            # if there are still higher ranges, check the next one for overlap
                            next;
                        }
                        else {
                            # there are no higher ranges, so I should just add this one
                            push @$tmp, [$minX, $maxX];
                        }
                    }
                    # range being added is contained within range being compared to
                    elsif ($rmin <= $minX && $maxX <= $rmax) {
                        # keep the containing range
                        push @$tmp, $rangeRef;
                        # don't lose the rest of the row
                        push @$tmp, @{$field[$row]};
                        # we're done with this row
                        last;
                    }
                    # range being added overlaps range being compared to on high side only
                    elsif (($rmin <= $minX && $minX <= $rmax) && $rmax < $maxX) {
                        # set minX to value of rmin, creating the union within minX and maxX
                        $minX = $rmin;
                        if (@{$field[$row]}) {
                            # if there are still higher ranges, check the next one
                            next;
                        }
                        else {
                            # there are no higher ranges, so I should just add this one
                            push @$tmp, [$minX, $maxX];
                        }    
                    }
                    # range being added is higher than range being compared to
                    elsif ($rmax < $maxX) {
                        # check if they're "touching" ...
                        if ($rmax + 1 == $minX) {
                            # set minX to value of rmin, creating the union within minX and maxX
                            $minX = $rmin;
                        }
                        else {
                            # keep the range we're comparing to
                            push @$tmp, $rangeRef;
                        }
                        if (@{$field[$row]}) {
                            # if there are still higher ranges, check the next one
                            next;
                        }
                        else {
                            # there are no higher ranges, so I should just add this one
                            push @$tmp, [$minX, $maxX];
                        }
                    }
                }
                # save the updated row into the field
                $field[$row] = $tmp;
                print STDERR "  Updated row: ", dump(@{$field[$row]}), "\n" if ($debug > 2);
            }
            warn "\n" if ($debug > 2);
        }
    }
    warn "\n" if ($debug > 1);
}

# This is really only useful with the test input
#dump(@field) if $debug > 0;

my $answer;
foreach my $row (0..@field-1) {
    if (scalar @{$field[$row]} == 2) {
        my $col = $field[$row][0][1] + 1;
        warn "Answer row = $row and col = $col\n" if ($debug > 0);
        $answer = ($col * 4000000) + $row;
    }
}

print "Answer: $answer\n";