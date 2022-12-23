#!/usr/bin/perl
use warnings;
use strict;

my $debug = 3;

my @map;
my @directions = (
    # Right
    [0,1],
    # Down
    [1,0],
    # Left
    [0,-1],
    # Up
    [-1,0]
);

while (<>) {
    chomp;
    last if ($_ =~ /^\s*$/);
    my @line = split (//, $_);
    push @map, \@line;
}

my @instructions = split(/([LR])/, <>);

my $row = 0;

my $col;
for my $i (0..(@{$map[0]}-1)) {
    if ($map[0][$i] eq '.') {
        $col = $i;
        last;
    }
}

my $heading = shift @directions;

warn join(',', @instructions), "\n" if ($debug > 0);

while (@instructions) {
    my $inst = shift @instructions;

    warn "Inst: $inst\n" if ($debug > 1);

    if ($inst eq 'R') {
        push @directions, $heading;
        $heading = shift @directions;
    }
    elsif ($inst eq 'L') {
        unshift @directions, $heading;
        $heading = pop @directions;
    }
    else {
        my $nextr = $row;
        my $nextc = $col;
        while ( $inst > 0 ) {
            $nextr += $$heading[0];
            $nextc += $$heading[1];

            warn "Location (r,c): ($row,$col)\n" if ($debug > 2);
            warn "Next (r,c): ($nextr,$nextc)\n" if ($debug > 2);

            if ( $$heading[0] == 1 || $$heading[0] == -1 ) {
                if ( $nextr == @map ) {
                    $nextr = 0;
                    warn "Updated Next to (r,c): ($nextr,$nextc)\n" if ($debug > 2);
                }
                elsif ( $nextr < 0 ) {
                    $nextr = @map - 1;
                    warn "Updated Next to (r,c): ($nextr,$nextc)\n" if ($debug > 2);
                }
            }
            else {
                if ( $nextc == @{$map[$nextr]} ) {
                    $nextc = 0;
                    warn "Updated Next to (r,c): ($nextr,$nextc)\n" if ($debug > 2);
                }
                elsif ( $nextc < 0 ) {
                    $nextc = @{$map[$nextr]} - 1;
                    warn "Updated Next to (r,c): ($nextr,$nextc)\n" if ($debug > 2);
                }
            }

            next if ( not defined $map[$nextr][$nextc] );
            next if ( $map[$nextr][$nextc] eq ' ' );
            last if ( $map[$nextr][$nextc] eq '#' );
            if ( $map[$nextr][$nextc] eq '.' ) {
                $row = $nextr;
                $col = $nextc;
                warn "Update Location to (r,c): ($nextr,$nextc)\n" if ($debug > 2);
                --$inst;
            }
        }
    }
}

my $answer = ($row+1)*1000 + ($col+1)*4;

if ( $$heading[0] == 1 ) {
    # Down
    ++$answer;
}
elsif ( $$heading[0] == -1 ) {
    # Up
    $answer += 3;
}
elsif ( $$heading[1] == -1 ) {
    # Left
    $answer += 2;
}

print "Answer: $answer\n";