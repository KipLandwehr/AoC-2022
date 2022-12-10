#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my $displayWidth = 40;
my $displayHeight = 6;

my @output;

my $x = 1;
my $cycle = 0;

while (<>) {
    chomp;
    ++$cycle;
    # print pixel after updating cycle
    my $pixel = ($cycle-1)%40;
    warn "\$x = $x, \$cycle = $cycle, \$pixel = $pixel\n" if $debug > 0;
    if ( ($x-1) <= $pixel && $pixel <= ($x+1) ) {
        warn "Adding # to output\n" if $debug > 0;
        push @output, '#';
    }
    else {
        warn "Adding . to output\n" if $debug > 0;
        push @output, '.';
    }

    my $num;
    if ($_ =~ /^addx (-?\d+)$/) {
        $num = $1;
        ++$cycle;
        # print pixel after updating cycle
        my $pixel = ($cycle-1)%40;
        warn "\$x = $x, \$cycle = $cycle, \$pixel = $pixel\n" if $debug > 0;
        if ( ($x-1) <= $pixel && $pixel <= ($x+1) ) {
            warn "Adding # to output\n" if $debug > 0;
            push @output, '#';
        }
        else {
            warn "Adding . to output\n" if $debug > 0;
            push @output, '.';
        }
    }
    $x += $num if (defined $num);
}

print "Output:\n";
print(splice(@output,0,$displayWidth), "\n") for (1..$displayHeight);