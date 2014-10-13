#!/usr/bin/perl
use strict;
use Data::Dumper;

main();

sub main
{
	my $n = <STDIN>;
	my @words;
	for(my $i=0; $i<$n; $i++)
	{
		my $line = <STDIN>;
		chomp($line);
		push (@words, $line);
	}
	my @letters;
	for(my $i=0; $i<$n-1; $i++)
	{
		my @firstWord = split('', $words[$i]);
		my @secondWord = split('', $words[$i+1]);
		my $k=0;
		for($k=0; $k<$n; $k++)
		{
			if($firstWord[$k] ne $secondWord[$k])
			{
				push(@letters, [$firstWord[$k], $secondWord[$k]]);
				last;
			}
		}
	}

	my @alphabet;
	push (@alphabet, $letters[0][0]);
	push (@alphabet, $letters[0][1]);
	shift @alphabet;
	my $k=0;
	while(scalar @letters)
	{
		my $flag = 0;
		for(my $i=0; $i < scalar @letters; $i++)
		{
			if ($alphabet[$k] eq $letters[$i][1])
			{
				for(my $l=$k; $l<scalar @alphabet; $l++)
				{
					if ($alphabet[$l] eq $letters[$i][0])
					{
						print "No";
						exit 0;
					}
				}
				unshift @alphabet, $letters[$i][0];
				splice @letters, $i, 1;
				$flag=1;
			}
		}
		my $flag2=0;
		if($flag==0)
		{
			for(my $i=0; $i < scalar @letters; $i++)
			{
				if ($alphabet[$k] eq $letters[$i][0])
				{
					for(my $l=$k; $l<scalar @alphabet; $l++)
					{
						if ($alphabet[$l] eq $letters[$i][1])
						{
							splice @letters, $i, 1;
							$flag2=1;
						}
					}
					if($flag2==0)
					{
						splice @alphabet, $k+1, 0, $letters[$i][1];
						splice @letters, $i, 1;
						$flag2=1;
					}
					else
					{
						$flag2=0;
					}
				}
			}
		}
		
		if($flag==0 && $flag2==0)
		{
			$k++;
		}
	}

	my @allLetters = ("a".."z");
	
	foreach my $i (@allLetters) 
	{
  		foreach my $k (@alphabet) 
  		{
    		$i =~ s/$k//g;
  		}
	}

	print @alphabet;
	print @allLetters; 
	print "\n";
}
