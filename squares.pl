#!/usr/bin/perl 
use strict;

use Data::Dumper;
use POSIX;

print "Enter n\n";
my $n = <STDIN>;
chomp($n);
while ($n != 2 && $n!=3)
{
	print "$n.";
	print "n must be 2 or 3. Enter n again\n";
	$n = <STDIN>;
} 

my $count=0;
my @square;

my $line;
for(my $i=0; $i<$n*$n; $i++)
{
	$line = <STDIN>;
	chomp( $line );
	if (length($line)!= $n*$n)
	{
		print "This line is unvalid\n";
		exit 0;
	}
	my @row = split("", $line);
	push(@square, \@row);
}

my @symbols;

foreach my $i (@square)
{
	foreach my $k (@$i)
	{
		if($k ne 0 && !($k eq ' '))
		{
			my $exists = 0;
			foreach my $a (@symbols)
			{
				if ($a eq $k)
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

if(scalar (@symbols) != $n* $n)
{
	print "Symbols not equales n\n";
	exit 0;
}


while(1)
{
	my $zeroes=0;

	for (my $i=0; $i<$n*$n; $i++)
	{
		for(my $k=0; $k<$n*$n; $k++)
		{
			if ($square[$i][$k] eq '0')
			{
				$zeroes++;
				my @currSymb;			
				for(my $ii=0; $ii<$n*$n; $ii++)
				{	
					if($ii==$i)
					{
						$ii++;
						if($ii == $n*$n)
						{
							last;
						}			
					}
					if ($square[$ii][$k] ne '0')
					{
						my $exists = 0;
						foreach my $a (@currSymb)
						{
							if ($a eq $square[$ii][$k])
							{
								$exists=1;
							}
						}

						if($exists==0)
						{
							push (@currSymb, $square[$ii][$k]);
						}
						
					}
				}
				for(my $kk=0; $kk<$n*$n; $kk++)
				{	
					if($kk==$k)
					{
						$kk++;
						if($kk == $n*$n)
						{
							last;
						}				
					}
					if ($square[$i][$kk] ne '0')
					{
						my $exists = 0;
						foreach my $a (@currSymb)
						{
							if ($a eq $square[$i][$kk])
							{
								$exists=1;
							}
						}

						if($exists==0)
						{
							push (@currSymb, $square[$i][$kk]);
						}
						
					}
				}
				
				for(my $iii= floor($i/ $n)*$n ; $iii< floor($i/$n)*$n+$n; $iii++)
				{
					for(my $kkk=floor($k/ $n)*$n; $kkk<floor($k/$n)*$n+$n; $kkk++)
					{
						if($iii==$i && $kkk==$k)
						{
							$kkk++;
							if($kkk == floor($k/$n)*$n+$n)
							{
								last;
							}
						}
						if ($square[$iii][$kkk] ne '0')
						{
							my $exists = 0;
							foreach my $a (@currSymb)
							{
								if ($a eq $square[$iii][$kkk])
								{
									$exists=1;
								}
							}

							if($exists==0)
							{
								push (@currSymb, $square[$iii][$kkk]);
							}
						
						}
					}
				}

				if (scalar @currSymb == $n*$n - 1)
				{
					foreach my $a (@symbols)
					{	
						my $exists = 0;
						foreach my $b (@currSymb)
						{
							if ($a eq $b)
							{
								$exists=1;
							}
							
						}
						if($exists==0)
						{
							$square[$i][$k] = $a;
							last;
						}
					}

				}
				@currSymb=();
			}
		}
	}
	if($zeroes == 0)
	{
		last;
	}
}

print Dumper \@square;

