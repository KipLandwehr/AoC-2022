#!/usr/bin/perl
use warnings;
use strict;

# Variables intended to be static
my $maxDirSize = 100000;

my $answer = 0;

# Read all input into an array
my @input;
while (<>) {
    chomp;
    push @input, $_;
}

# calculate the total value of this directory (/).
my $total = getTotalValue(\@input);

if ($total <= $maxDirSize) {
    $answer += $total;
}

print "Answer: $answer\n";

sub getTotalValue {
    my $aref = shift;
    my $total = 0;

    # Get number of arguments
    my $args = @$aref;

    while ($args > 0) {
        my $line = shift(@$aref);
        if ($line =~ /^\$ cd \.\.$/) {
            $answer += $total if ($total <= $maxDirSize);
            return $total;
        }
        elsif ($line =~ m!^\$ cd [a-z/]+$!) {
            $total += getTotalValue($aref);
        }
        elsif ($line =~ /^(\d+) [a-z.]+$/) {
            $total += $1;
        }
        elsif ($line =~ /^\$ ls$/) {
            next;
        }
        elsif ($line =~ /^dir [a-z]+$/) {
            next;
        }
        $args = @$aref;
    }
    # Should only get here at the end of all input.
    # That's the end of a directory, just like "cd .."
    # so treat it the same way.
    $answer += $total if ($total <= $maxDirSize);
    return $total;
}