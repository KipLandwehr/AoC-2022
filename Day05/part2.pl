#!/usr/bin/perl
use warnings;
use strict;

my $readingStacks = 1;
my $isFirstLine = 1;
my $numStacks;

# @stacks will be a list of lists, which I'll treat as
# stacks[stackNum][boxNum] = boxLabel
my @stacks;

while (<>) {
    chomp;
    if ($_ =~ /^$/) {
        $readingStacks = 0;
        next;
    }

    if ($isFirstLine) {
        # Each stack is composed by '[X] ', or 4 characters, except
        # for the last column, which doesn't have the trailing ' '.
        # So, get length, add 1 for the trailing space, then div 4
        # to get the number of stacks.
        $numStacks = ((length $_) + 1) / 4;

        # For each stack, create an empty list to put its boxes into.
        for (my $i = 0; $i < $numStacks; $i++) {
            unshift @stacks, [];
        }

        # And we can't have another first line, so set isFirstLine to 'false'
        $isFirstLine = 0;
    }

    if ($readingStacks) {
        my @chars = split(//, $_);
        # Box labels are are position 4n+1
        for (my $stack = 0; $stack < $numStacks; ++$stack) {
            #getLabel
            my $label = $chars[((4 * $stack) + 1)];
            # if label is an uppercase character
            if ($label ~~ ['A'..'Z']) {
                unshift @{ $stacks[$stack] }, $label;
            }
        }
    }
    else {
        # print the set of stacks ...
        #for (my $i = 0; $i < $numStacks; ++$i) {
        #    my $stackNum = $i + 1;
        #    print "$stackNum:";
        #    foreach (@{$stacks[$i]}) {
        #        print " $_";
        #    }
        #    print "\n";
        #}
        #print "\n";
        
        # now reading movement instructions...
        $_ =~ /move (\d+) from (\d+) to (\d+)/ or die "error processing instructions\n";
        
        # Subtract 1 from stack numbers because mine are 0 indexed and the problem's are 1 indexed
        my ($numBoxes, $srcStack, $dstStack) = ($1, ($2-1), ($3-1));
        
        my @tmp;
        for (my $i=0; $i < $numBoxes; $i++) {
            unshift ( @tmp, ( pop @{$stacks[$srcStack]} ) );
        }
        push ( @{$stacks[$dstStack]}, @tmp );
    }
}

# Print Answer
print "Answer: ";
for (my $i = 0; $i < $numStacks; $i++) {
    my $label = pop(@{$stacks[$i]});
    print "$label";
}
print "\n";