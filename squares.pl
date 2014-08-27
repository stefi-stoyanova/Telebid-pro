#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Dumper;

my $count=0;
my @square;
foreach my $line ( <STDIN> ) 
{

    chomp( $line );
    my @row = split("", $line); 	
  	push(@square, \@row);
}



my @symbols;
foreach my $i (@square)
{
	foreach my $k (@$i)
	{
		if($k!=0 && !($k eq ' '))
		{
			my $exists = 0;
			foreach my $a (@symbols)
			{
				if ($a == $k)
				{
					$exists=1;
				}
			}
			if($exists==0)
			{
				push (@symbols, $k);
			}
		}
	}
}

print @symbols;

