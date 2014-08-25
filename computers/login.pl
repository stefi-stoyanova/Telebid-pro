#!/usr/bin/perl -w
use CGI;
use DBI;
use warnings;


print "Content-type: text/html\n\n";


my $dsn = "DBI:Pg:dbname=computers;host=127.0.0.1;port=5432";
my $userid = "postgres";
my $password = "Imamazing!";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })or die $DBI::errstr;


my $q = CGI->new;
my $username = $q->param('username');
my $password = $q->param('password');


my $sth = $dbh->prepare("SELECT count(*) FROM users WHERE username = '$username' AND password = '$password'") or return undef;
$sth->execute() or die "DBI::errstr";
my $isUser = $sth->fetchrow_array();

if ($isUser)
{
	print 1;
}
else
{
	print 0;
}
