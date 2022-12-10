#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my @head = (0,0);
my @tail = (0,0);
my @offset = (0,0);
my %moves = (
    U => [0,1],
    D => [0,-1],
    L => [-1,0],
    R => [1,0]
);


my %positions;
# tail starts at 0,0
++$positions{"$tail[0],$tail[1]"};

while (<>) {
    chomp;
    my ($move, $num) = split;
    my @mv = @{$moves{$move}};
    warn "Moving $move, $num times\n" if $debug > 1;
    foreach (1..$num) {
        warn "Iteration $_\n" if $debug > 2;
        # starting head position
        my @sHead = @head;
        # move head
        $head[0] += $mv[0];
        $head[1] += $mv[1];
        # new offset
        $offset[0] = $head[0] - $tail[0];
        $offset[1] = $head[1] - $tail[1];
        warn "Offset after moving head = $offset[0],$offset[1]\n" if $debug > 2;
        # move tail, if necessary;
        if ( abs($offset[0]) > 1 || abs($offset[1]) > 1 ) {
            @tail = @sHead;
            warn "adding position $tail[0],$tail[1]\n" if $debug > 2;
            ++$positions{"$tail[0],$tail[1]"};
        }
    }
}

warn "Positions has ", scalar %positions, " positions. Positions are...\n" if $debug > 0;
if ($debug > 0) {
    warn "$_\n" foreach (keys %positions);
}

print "Answer: ", scalar %positions, "\n";