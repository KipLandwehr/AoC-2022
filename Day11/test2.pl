#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;

my %monkeys = (
    0 => {
        items => [79, 98],
        op => \&m0op,
        test => {
            denom => 23,
            t => 2,
            f => 3,
        },
    },
    1 => {
        items => [54, 65, 75, 74],
        op => \&m1op,
        test => {
            denom => 19,
            t => 2,
            f => 0,
        },
    },
    2 => {
        items => [79, 60, 97],
        op => \&m2op,
        test => {
            denom => 13,
            t => 1,
            f => 3,
        },
    },
    3 => {
        items => [74],
        op => \&m3op,
        test => {
            denom => 17,
            t => 0,
            f => 1,
        },
    },
);

my $numRounds = 10000;

my $stressReducer = 1;
foreach my $monkey (0..3) {
    $stressReducer *= $monkeys{$monkey}{test}{denom};
}

my @inspections;

for my $round (1..$numRounds) {
    warn "Round $round\n" if $debug > 2;
    foreach my $monkey (0..3) {
        warn "Monkey $monkey\n" if $debug > 2;
        while (@{$monkeys{$monkey}{items}}) {
            my $item = shift @{$monkeys{$monkey}{items}};
            warn "\$item = $item\n" if $debug > 2;
            $item = int($monkeys{$monkey}{op}($item) % $stressReducer);
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
    if ($debug > 0) {
        if ( $round == 1 || $round == 20 || $round == 1000
          || $round == 2000 || $round == 3000 || $round == 4000
          || $round == 5000 || $round == 6000 || $round == 7000
          || $round == 8000 || $round == 9000 || $round == 10000 ) {
            warn "== After round $round ==\n";
            warn "Monkey 0 inspected items $inspections[0] times.\n";
            warn "Monkey 1 inspected items $inspections[1] times.\n";
            warn "Monkey 2 inspected items $inspections[2] times.\n";
            warn "Monkey 3 inspected items $inspections[3] times.\n";
        }
    }
}

@inspections = sort { $a <=> $b } @inspections;

if ($debug > 0) {
    foreach my $count (@inspections) {
        print "$count ";
    }
    print "\n";
}

my $answer = (pop @inspections) * (pop @inspections);
print "Answer: $answer\n";

sub m0op {
    my $x = shift;
    return $x * 19;
}
sub m1op {
    my $x = shift;
    return $x + 6;
}
sub m2op {
    my $x = shift;
    return $x * $x;
}
sub m3op {
    my $x = shift;
    return $x + 3;
}