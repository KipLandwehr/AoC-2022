#!/usr/bin/perl
use warnings;
use strict;

my $answer = 0;

# Create hash of item (letter) values ...
my $number = 0;
my %values = map {$_ => ++$number} ('a'..'z','A'..'Z');

while (<>) {
    chomp;
    ## Length returns 1 more than I'm expecting, even with chomp.
    ## The last line was working as expected until I added a new blank line at the end of the file
    ## Not sure why chomp isn't removing all newline characters. Maybe only specific to this OS?
    ## In any case, I'm subtracting 1 to combat this issue, and will make sure I have a blank line at the end of my input file.
    my $length = (length $_) - 1;
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