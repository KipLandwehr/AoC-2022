#!/usr/bin/perl
use warnings;
use strict;

my $answer = 0;

# Create hash of item (letter) values ...
my $number = 0;
my %values = map {$_ => ++$number} ('a'..'z','A'..'Z');

my %elf1;
my %elf12;
my $lineno = 0;

while (<>) {
    chomp;

    my @letters = split(//, $_);

    # First in group of elves
    if (($lineno % 3) == 0) {
        %elf1 = ();
        %elf1 = map {$_ => 1} @letters;
    }

    # Second in group of elves
    elsif (($lineno % 3) == 1) {
        %elf12 = ();
        foreach my $letter (@letters) {
            $elf12{$letter} = 1 if (exists $elf1{$letter});
        }
    }
    
    # Third in group of elves
    elsif (($lineno % 3) == 2) {
        foreach my $letter (@letters) {
            if (exists $elf12{$letter}) {
                $answer += $values{$letter};
                last;
            }
        }
    }

    ++$lineno;
}

print "Answer: $answer\n";