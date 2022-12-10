#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my $numKnots = 10;

my %moves = (
    U => [0,1],
    D => [0,-1],
    L => [-1,0],
    R => [1,0]
);

my %translations = (
    "0,2" => [0,1],     # N
    "2,0" => [1,0],     # E
    "2,2" => [1,1],     # NE
    "2,1" => [1,1],     # NE
    "1,2" => [1,1],     # NE
    "0,-2" => [0,-1],   # S
    "-2,0" => [-1,0],   # W
    "-2,2" => [-1,1],   # NW
    "-2,1" => [-1,1],   # NW
    "-1,2" => [-1,1],   # NW
    "2,-2" => [1,-1],   # SE
    "2,-1" => [1,-1],   # SE
    "1,-2" => [1,-1],   # SE
    "-2,-2" => [-1,-1], # SW
    "-2,-1" => [-1,-1], # SW
    "-1,-2" => [-1,-1], # SW
);

my %positions;
my %visited;

# All knots start at 0,0 and therefore have all visited 0,0
foreach my $knot (1..$numKnots) {
    $positions{$knot} = [0, 0];
    ++$visited{$knot}{"0,0"};
}

while (<>) {
    chomp;
    my ($move, $num) = split;
    my @mv = @{$moves{$move}};
    warn "Moving $move, $num times\n" if $debug > 1;
    foreach (1..$num) {
        warn "Iteration: $_\n" if $debug > 2;
        # previous position of the knot in front of us
        # set to the Head knot's starting position to start
        my @leadingKnotPrevPos = @{$positions{1}};

        # for first knot, alway do the move...
        $positions{1}[0] += $mv[0];
        $positions{1}[1] += $mv[1];
        # and record its visit to its new position
        ++$visited{1}{"$positions{1}[0],$positions{1}[1]"};

        KNOTS: foreach my $knot (2..$numKnots) {
            my @offset;
            warn "Knot $knot\n" if $debug > 3;
            $offset[0] = $positions{$knot-1}[0] - $positions{$knot}[0];
            $offset[1] = $positions{$knot-1}[1] - $positions{$knot}[1];
            warn "Offset: ($offset[0],$offset[1])\n" if $debug > 3;

            # move knot if we need to
            if ( abs($offset[0]) > 1 || abs($offset[1]) > 1 ) {   
                warn "Moving knot $knot\n" if $debug > 4;
                # get translation
                my @tr = @{$translations{"$offset[0],$offset[1]"}};
                # do the translation
                $positions{$knot}[0] += $tr[0];
                $positions{$knot}[1] += $tr[1];
                warn "Set position to ($positions{$knot}[0],$positions{$knot}[1])\n" if $debug > 4;
                ++$visited{$knot}{"$positions{$knot}[0],$positions{$knot}[1]"};
            }
            else {
                warn "Knot $knot unmoved\n" if $debug > 4;
                # if we don't need to move this knot
                # then we don't need to move any behind it either
                last;
            }
        }
    }
}

print "Answer: ", scalar %{$visited{$numKnots}}, "\n";