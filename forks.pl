use Parallel::ForkManager 0.7.6;
use strict;
use warnings;
use DBI;
use Try::Tiny;
use Time::HiRes qw(usleep time);




sub startThread($$$$)
{
    my($isolation, $sleep, $startTime, $i) = @_;

    
    my $dbh = DBI->connect('dbi:Pg:dbname=test;host=localhost', 'postgres', '123456',{AutoCommit => 0, RaiseError => 1, PrintError => 0});
       
    my $requests = { 
        successfull => 0,
        all => 0,
    };
    #my $start = time(); 
    while( time() - $startTime <= 60) 
    {
        $$requests{all}++;
        try
        {
            #print "$i ";
            my $sth = $dbh->prepare("SET TRANSACTION ISOLATION LEVEL $isolation") or die;
            $sth->execute();
            
            $sth = $dbh->prepare("SELECT SUM(num) FROM a;");
            $sth->execute();
            my $row = $sth->fetchrow_hashref();


            my $randID = int(rand(10)) + 1;
            my $rand = int(rand(100));
            $sth = $dbh->prepare("UPDATE a SET num = '$rand' WHERE id = '$randID'");
            $sth->execute(); 

            $sth = $dbh->prepare("SELECT SUM(num) FROM a;");
            $sth->execute(); 
            
            sleep($sleep);
            #usleep($sleep);
            #print "\n";
            
            $dbh->commit();

            $$requests{successfull}++;
       
        }
        catch
        {
            my ($err) = @_;
            $dbh->rollback();
            #print $err;

        };
    }

    $dbh->disconnect;
    return $requests;
   
}


my $pm = Parallel::ForkManager->new(100);
 
my $successCounter = 0;
my $allCounter = 0;
my $isolation = 'REPEATABLE READ';
my $sleep = 0;

$pm -> run_on_finish ( 
    sub {
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $requests) = @_;
  
        if (defined($requests)) { 
            $successCounter += $$requests{successfull};
            $allCounter += $$requests{all}
        }
    }
);
 

my $startTime = time();
LOOP:
for my $i (1..100) {
    $pm->start() and next LOOP;

    my $requests = startThread($isolation, $sleep, $startTime, $i);


    $pm->finish(0, $requests);
}

$pm->wait_all_children;

print "success: $successCounter\n";
print "all: $allCounter\n";
print "isolation: $isolation\n";
print "sleep: $sleep\n";



