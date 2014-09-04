#!/usr/bin/perl -w
use CGI;
use DBI;
use warnings;
use CGI::Session;


print "Content-type: text/html\n\n";



my $q = CGI->new;

my $sid = $q->cookie("CGISESSID") || undef;
if($sid eq undef)
{
	print "not logged in";
	return;
}

my $session = new CGI::Session(undef, $sid, {Directory=>'/tmp'});
  undef($session);
$session->delete;	