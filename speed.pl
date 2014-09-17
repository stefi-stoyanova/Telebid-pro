#!/usr/bin/perl 
use strict;

use Data::Dumper;

print "Enter N M \n";
my $line = <STDIN>;
my ($n, $m) = split(" ", $line);

if($n<2 || $n>1000 || $m<1 || $m>10000)
{
	exit 0;
}

my @roads;

for(my $i=0; $i<$m; $i++)
{
	$line = <STDIN>;
	($roads[$i][0], $roads[$i][1], $roads[$i][2]) = split(" ", $line);

	if($roads[$i][0]<1 || $roads[$i][0]>$n || $roads[$i][1]<1 || $roads[$i][1]>$n || $roads[$i][2]<1 || $roads[$i][2]>30000)
	{
		exit 0;
	}
}

while(scalar @roads > $n-1)
{
	my $speed = 0;
	for (my $i=0; $i < scalar @roads; $i++)
	{
		$speed+=$roads[$i][2];
	}
	$speed /= scalar @roads;
	print $speed;
	

	my $razlika = 0;
	my $removeIndex = -1;
	for (my $i=0; $i < scalar @roads; $i++)
	{
		
		if (absolute($speed - $roads[$i][2]) > $razlika)
		{
			if($removeIndex!=$i)
			{
				
				$razlika = absolute($speed - $roads[$i][2]);
				$removeIndex = $i;
			}
		}
	}

	my $first= 0;
	my $second = 0;	
	for(my $i=0; $i < scalar @roads; $i++)
	{
		if($i!=$removeIndex)
		{
				if($roads[$removeIndex][0] == $roads[$i][0] || $roads[$removeIndex][0] == $roads[$i][1])
				{
					$first = 1;
				}
				if($roads[$removeIndex][1] == $roads[$i][0] || $roads[$removeIndex][1] == $roads[$i][1])
				{
					$second = 1;
				}
		}
	}

	if($first==1 && $second==1)
	{
		print "removing: $removeIndex\n";
		splice @roads, $removeIndex, 1;
	}
	print Dumper @roads;
	
}

my $min=1000;
my $max = -1;

for(my $i=0; $i < scalar @roads; $i++)
{
	if($roads[$i][2]>$max)
	{
		$max = $roads[$i][2];	
	}

	if($roads[$i][2]<$min)
	{
		$min = $roads[$i][2];	
	}
}

print "$min $max";


sub absolute($)
{
	my ($number) = @_;
	if ($number >0)
	{
		return $number;
	}
	else
	{
	 	return -$number;
	}
}
