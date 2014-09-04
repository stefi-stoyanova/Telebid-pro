#!/usr/bin/perl -w
use CGI;
use DBI;
use warnings;
use Crypt::PBKDF2;
use Email::Valid;

print "Content-type: text/html\n\n";

try
{
	my $dsn = "DBI:Pg:dbname=computers;host=127.0.0.1;port=5432";
	my $userid = "postgres";
	my $pass = "Imamazing!";
	my $dbh = DBI->connect($dsn, $userid, $pass, { RaiseError => 1 })or die $DBI::errstr;


	my $q = CGI->new;
	my $username = $q->param('username');
	my $password = $q->param('password');
	my $email = $q->param('email');

	my $isValid = Email::Valid->address($email);
  	if(! $isValid)
  	{
  		print 4;
  		exit 0;
  	}


	my $sth = $dbh->prepare("SELECT count(*) FROM users WHERE username = ?") or return undef;
	$sth->execute($username) or die "DBI::errstr";
	my $isUser = $sth->fetchrow_array();

	if ($isUser)
	{
		print 1;
		exit 0;
	}

	$sth = $dbh->prepare("SELECT count(*) FROM users WHERE email = ?") or return undef;
	$sth->execute($email) or die "DBI::errstr";
	$isUser = $sth->fetchrow_array();
	if ($isUser)
	{
		print 3;
		exit 0;
	}
	else
	{


	    my $pbkdf2 = Crypt::PBKDF2->new(hash_class => 'HMACSHA2');

	    my $hash = $pbkdf2->generate($password, $users);
	    open(MYFILE, ">>hash.txt");
	    print MYFILE $hash;

		$sth = $dbh->prepare("INSERT INTO users (username, password, email)  VALUES  (? , ?, ?)") or return undef;
		$sth->execute($username, $hash, $email) or die "DBI::errstr";
		print 2;
		exit 0;
	}
}
catch
{
	print "There'is unexpected error";
}
