#!/usr/bin/perl
use warnings;
use strict;

my $number;
my %values = map {$_ => ++$number} ('a'..'z');
$values{S} = $values{a};
$values{E} = $values{z};


my @input;
while (<>) {
    chomp;
    push @input, [ split(//) ];
}

my $height = @input;
my $width = @{$input[1]};
my @start;
my @end;

my %visited;
my @checkNext;

# find S and E coordinates
# also translate each letter into a number
foreach my $row (0 .. $height-1) {
    foreach my $col (0 .. $width-1) {
        if ($input[$row][$col] eq 'S') {
            @start = ($row, $col);
            $visited{$row}{$col} = 0;
            push @checkNext, ($row, $col);
        }
        elsif ($input[$row][$col] eq 'E') {
            @end = ($row, $col);
        }
        elsif ($input[$row][$col] eq 'a') {
            $visited{$row}{$col} = 0;
            push @checkNext, ($row, $col);
        }

        $input[$row][$col] = $values{$input[$row][$col]};
    }
}

# this will find everything that's one step away from an 'a',
# then two steps away, and so on
while (@checkNext) {
    my $row = shift @checkNext;
    my $col = shift @checkNext;

    # Break out of while loop if we're at E
    last if ($row == $end[0] && $col == $end[1]);

    # set distance I'll be assigning to valid next coordinates
    my $ndist = $visited{$row}{$col} + 1;
    
    # check north is in bounds
    if ($row > 0) {
        # if north has not been visited and I can step to it...
        if ( (not (defined $visited{$row-1}{$col})) && ($input[$row-1][$col] <= $input[$row][$col]+1) ) {
            # add to list to check
            push @checkNext, ($row-1);
            push @checkNext, $col;
            # and mark as visited
            $visited{$row-1}{$col} = $ndist;
        }
    }
    # check east is in bounds
    if ($col < $width-1) {
        # if east has not been visited and I can step to it...
        if ( (not (defined $visited{$row}{$col+1})) && ($input[$row][$col+1] <= $input[$row][$col]+1) ) {
            # add to list to check
            push @checkNext, $row;
            push @checkNext, ($col+1);
            # and mark as visited
            $visited{$row}{$col+1} = $ndist;
        }
    }
    # check south is in bounds
    if ($row < $height-1) {
        # if south has not been visited and I can step to it...
        if ( (not (defined $visited{$row+1}{$col})) && ($input[$row+1][$col] <= $input[$row][$col]+1) ) {
            # add to list to check
            push @checkNext, ($row+1);
            push @checkNext, $col;
            # and mark as visited
            $visited{$row+1}{$col} = $ndist;
        }
    }
    # check west is in bounds
    if ($col > 0) {
        # if west has not been visited and I can step to it...
        if ( (not (defined $visited{$row}{$col-1})) && ($input[$row][$col-1] <= $input[$row][$col]+1) ) {
            # add to list to check
            push @checkNext, $row;
            push @checkNext, ($col-1);
            # and mark as visited
            $visited{$row}{$col-1} = $ndist;
        }
    }
}

my $answer = $visited{$end[0]}{$end[1]};

print "Answer = $answer\n";