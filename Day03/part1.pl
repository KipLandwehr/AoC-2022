#!/usr/bin/perl
use warnings;
use strict;

my $answer = 0;

# Create hash of item (letter) values ...
my $number = 0;
my %values = map {$_ => ++$number} ('a'..'z','A'..'Z');

while (<>) {
    chomp;
    my $length = (length $_);
    my $half = $length / 2;
    my @letters = split(//, $_);
    my %half1;
    for (my $i=0; $i<$half; $i++) {
        if ($half1{$letters[$i]}) {
            ++$half1{$letters[$i]}
        }
        else {
            $half1{$letters[$i]} = 1;
        }
    }
    for (my $i=$half; $i<$length; $i++) {
        if (exists $half1{$letters[$i]}) {
            $answer += $values{$letters[$i]};
            last;
        }
    }
}

print "Answer: $answer\n";