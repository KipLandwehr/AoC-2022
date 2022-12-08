#!/usr/bin/perl
use warnings;
use strict;

# Variables intended to be static
my $totalSpace = 70000000;
my $totalSpaceNeeded = 30000000;

my @dirSizes;

# Read all input into an array
my @input;
while (<>) {
    chomp;
    push @input, $_;
}

# calculate the total value of this directory (/).
my $rootSize = getDirSizes(\@input);

my $spaceAvailable = $totalSpace - $rootSize;
my $spaceToFree = $totalSpaceNeeded - $spaceAvailable;

my $answer = $rootSize;
foreach my $size (@dirSizes) {
    $answer = $size if ($size > $spaceToFree and $size < $answer);
}

print "Answer: $answer\n";


# Yes I know I'm using this function to affect things outside this function
# Yes I know that's bad practice
# No I don't care (in the context of AoC)
sub getDirSizes {
    my $aref = shift;
    my $total = 0;

    # Get number of arguments
    my $args = @$aref;

    while ($args > 0) {
        my $line = shift(@$aref);
        if ($line =~ /^\$ cd \.\.$/) {
            push @dirSizes, $total;
            return $total;
        }
        elsif ($line =~ m!^\$ cd [a-z/]+$!) {
            $total += getDirSizes($aref);
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
    push @dirSizes, $total;
    return $total;
}