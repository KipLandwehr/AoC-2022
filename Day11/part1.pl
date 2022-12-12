#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my %monkeys = (
    0 => {
        items => [75, 75, 98, 97, 79, 97, 64],
        op => \&m0op,
        test => {
            denom => 19,
            t => 2,
            f => 7,
        },
    },
    1 => {
        items => [50, 99, 80, 84, 65, 95],
        op => \&m1op,
        test => {
            denom => 3,
            t => 4,
            f => 5,
        },
    },
    2 => {
        items => [96, 74, 68, 96, 56, 71, 75, 53],
        op => \&m2op,
        test => {
            denom => 11,
            t => 7,
            f => 3,
        },
    },
    3 => {
        items => [83, 96, 86, 58, 92],
        op => \&m3op,
        test => {
            denom => 17,
            t => 6,
            f => 1,
        },
    },
    4 => {
        items => [99],
        op => \&m4op,
        test => {
            denom => 5,
            t => 0,
            f => 5,
        },
    },
    5 => {
        items => [60, 54, 83],
        op => \&m5op,
        test => {
            denom => 2,
            t => 2,
            f => 0,
        },
    },
    6 => {
        items => [77, 67],
        op => \&m6op,
        test => {
            denom => 13,
            t => 4,
            f => 1,
        },
    },
    7 => {
        items => [95, 65, 58, 76],
        op => \&m7op,
        test => {
            denom => 7,
            t => 3,
            f => 6,
        },
    },
);

my $numRounds = 20;

my @inspections;

for my $round (1..$numRounds) {
    warn "Round $round\n" if $debug > 1;
    foreach my $monkey (0..7) {
        warn "Monkey $monkey\n" if $debug > 2;
        while (@{$monkeys{$monkey}{items}}) {
            my $item = shift @{$monkeys{$monkey}{items}};
            warn "\$item = $item\n" if $debug > 3;
            $item = int($monkeys{$monkey}{op}($item) / 3);
            ++$inspections[$monkey];
            if ($item % $monkeys{$monkey}{test}{denom} == 0) {
                my $throwTo = $monkeys{$monkey}{test}{t};
                push @{$monkeys{$throwTo}{items}}, $item;
            }
            else {
                my $throwTo = $monkeys{$monkey}{test}{f};
                push @{$monkeys{$throwTo}{items}}, $item;
            }
        }
    }
}

@inspections = sort { $a <=> $b } @inspections;

if ($debug > 0) {
    while (@inspections) {
        $_ = shift @inspections;
        print "$_ ";
    }
    print "\n";
}

my $answer = (pop @inspections) * (pop @inspections);
print "Answer: $answer\n";

sub m0op {
    my $x = shift;
    return $x * 13;
}
sub m1op {
    my $x = shift;
    return $x + 2;
}
sub m2op {
    my $x = shift;
    return $x + 1;
}
sub m3op {
    my $x = shift;
    return $x + 8;
}
sub m4op {
    my $x = shift;
    return $x * $x;
}
sub m5op {
    my $x = shift;
    return $x + 4;
}
sub m6op {
    my $x = shift;
    return $x * 17;
}
sub m7op {
    my $x = shift;
    return $x + 5;
}