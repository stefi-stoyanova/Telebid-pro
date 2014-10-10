#!/usr/bin/perl 
use strict;

use Data::Dumper;
use Time::HiRes qw/ time /;

main();

sub main
{
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

    my @roadsToStay;
    my $currTime = time;
    
    my $speed = 0;
    my $sumSpeeds = 0;

    my $size = scalar @roads;
    for (my $i=0; $i < $size; $i++)
    {
        $sumSpeeds+=$roads[$i][2];
    }

    while(scalar @roads > $n-1)
    {
        $speed = $sumSpeeds/(scalar @roads);
        my $removeIndex = -1;
        my $razlika = 0;

        $size = scalar @roads;
        for (my $i=0; $i < $size; $i++)
        {
            if (absolute($speed - $roads[$i][2]) >= absolute($razlika))
            {
                if(absolute($speed - $roads[$i][2]) == $razlika)
                {
                    last;
                }
        
                if(!isThere($roads[$i][0], $roads[$i][1], \@roadsToStay))
                {
                    $razlika = $speed - $roads[$i][2];
                    $removeIndex = $i;
                }   
                
            }
        }
        
        my @r = @roads;
        splice @r, $removeIndex, 1;
        my $res = hasPath($n, \@r);
                
        if($res)
        {
            $sumSpeeds-= $roads[$removeIndex][2];
            splice @roads, $removeIndex, 1;
        }
        else
        {
            push (@roadsToStay, $roads[$removeIndex]);
        }
        
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

    print "\nTime: " . (time - $currTime) . " sec.\n";
    print "$min $max";
}



sub isThere($$$)
{
    my($x, $y, $ref) = @_;
    my @arr = @{ $ref };

    for(my $i=0; $i < scalar @arr; $i++)
    {
        if(($arr[$i][0] == $x && $arr[$i][1] == $y) 
            || ($arr[$i][1] == $x && $arr[$i][0] == $y))
        {
            return 1;
        }
    }
    return 0;
}

sub hasPath($$)
{
    my($n, $roadsRef) = @_;
    my @roads = @{ $roadsRef };
    my @tail;
    my @numbers;

    push(@tail, $roads[0][0]);
    push(@tail, $roads[0][1]);
    splice @roads, 0, 1;
    while(scalar @tail)
    {
        if(has($tail[0], \@numbers))
        {
            splice @tail, 0, 1;
            next;
        }
        for(my $i=0; $i<scalar @roads; $i++)
        {
            if($roads[$i][0] == $tail[0])
            {
                push(@tail, $roads[$i][1]);
                splice @roads, $i, 1;
                $i--;
            } 
            elsif($roads[$i][1] == $tail[0])
            {
                push(@tail, $roads[$i][0]);
                splice @roads, $i, 1;
                $i--;
            } 

        }
        push(@numbers, $tail[0]);
        splice @tail, 0, 1;
    }

    if (scalar @numbers == $n)
    {
        return 1;
    }
    return 0;
}

sub has($$)
{
    my($x, $arrRef) = @_;
    my @arr = @{ $arrRef };
    for my $el (@arr)
    {
        if($el == $x)
        {
            return 1;
        }
    }
    return 0;
}

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

