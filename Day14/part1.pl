#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

# Sand source is x,y = 500,0
# aka row,col = 0,500
# using row column in case printing
my @sandSrc = (0,500);
my @cave;

while (<>) {
    chomp;
    my @coords = split " -> ";
    foreach my $i (1..@coords-1) {
        my ($pcol, $prow) = split ',', $coords[$i-1];
        my ($col, $row) = split ',', $coords[$i];
        if ($pcol == $col) {
            if ($prow < $row) {
                foreach my $val ($prow .. $row) {
                    $cave[$val][$col] = '#';
                }
            }
            else {
                foreach my $val ($row .. $prow) {
                    $cave[$val][$col] = '#';
                }
            }
        }
        else {  # $prow == $row
            if ($pcol < $col) {
                foreach my $val ($pcol .. $col) {
                    $cave[$row][$val] = '#';
                }
            }
            else {
                foreach my $val ($col .. $pcol) {
                    $cave[$row][$val] = '#';
                }
            }
        }
    }
}

# print test input
#foreach my $r (0..9) {
#    foreach my $c (494..503) {
#        if ($cave[$r][$c]) { print $cave[$r][$c]; }
#        else { print '.'; }
#    }
#    print "\n";
#}

warn "Number of rows in cave = ", scalar(@cave), "\n" if ($debug > 0);

my $answer;

while (++$answer) {
    warn "$answer\n" if ($debug > 0);
    
    #sim sand grain starting at r0, c500
    my $row = $sandSrc[0];
    my $col = $sandSrc[1];

    # If my position is equal to the lowest row (greatest value), then I'm at the bottom and in
    # the floor? (No, just on the same row and about to fall below the puzzle area.)
    # In which case, I've fallen off and can print the answer.
    # I could maybe check to see if I'm off the right side, but I'd have to find
    # the max row length and that's a minor cost savings
    while ($row < (scalar(@cave)-1)) {
        #warn "Coord (r,c): ($row, $col)\n" if ($debug > 1);
        warn "Coord (r,c): ($row, $col) with ", scalar @cave, " rows\n" if ($debug > 1);

        if (not (defined $cave[$row+1][$col])) {
            warn "Matched condition 1\n" if ($debug > 2);
            ++$row;
        }
        elsif (not (defined $cave[$row+1][$col-1])) {
            warn "Matched condition 2\n" if ($debug > 2);
            ++$row;
            --$col;
        }
        elsif (not (defined $cave[$row+1][$col+1])) {
            warn "Matched condition 3\n" if ($debug > 2);
            ++$row;
            ++$col;
        }
        else {
            warn "Matched condition 4\n" if ($debug > 2);
            $cave[$row][$col] = 'o';
            last;
        }
    }
    last if ($row == (scalar @cave)-1);
}

# Technically answer's value is the first grain of sand to fall into the abyss
# The puzzle wants the last grain that doesn't, so subtract 1

print "Answer: ", $answer-1, "\n";