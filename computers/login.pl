#!/usr/bin/perl -w
use CGI;
use DBI;
use warnings;
use Crypt::PBKDF2;



print "Content-type: text/html\n\n";


my $dsn = "DBI:Pg:dbname=computers;host=127.0.0.1;port=5432";
my $userid = "postgres";
my $password = "Imamazing!";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })or die $DBI::errstr;


my $q = CGI->new;

my $username = $q->param('username');
my $pass = $q->param('password');


my $sth = $dbh->prepare("SELECT password FROM users WHERE username = ? ") or return undef;
$sth->execute($username) or die "DBI::errstr";
my $hash = $sth->fetchrow_array();


my $pbkdf2 = Crypt::PBKDF2->new(hash_class => 'HMACSHA2');
my $isUser = $pbkdf2->validate($hash, $pass);

if ($isUser)
{
	print 1;
}
else
{
	print 0;
}
