use DBI;
use strict;
use Spreadsheet::ParseExcel;
use utf8;


sub insert
{
	
	use strict;
	use Spreadsheet::ParseExcel;
	my $oExcel = new Spreadsheet::ParseExcel;


	my $oBook = $oExcel->Parse($_[2]);
	my $wSheet = $oBook->{Worksheet}[0];
	
	my $minRows = $wSheet->{MinRow};
	my $maxRows = $wSheet-> {MaxRow};
	my $minCols = $wSheet-> {MinCol};
	my $maxCols = $wSheet-> {MaxCol};

	
        for(my $row = $minRows+2; $row <= $maxRows ; $row++) {
		my @arr = ();
		for(my $col = $minCols; $col <= $maxCols; $col++){
			my $cell = $wSheet->{Cells}[$row][$col];
			if($cell)
			{	
				if($wSheet->{Cells}[0][$col]->value() ne'abc')
				{
					$arr[$col] =  $cell->value();
				}
			}
		}
		$_[0]->do($_[1], undef, @arr);
		
        }
}

sub insertDoc
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_doc.xls';
	my $query = "INSERT INTO ek_doc VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertKmet
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_kmet.xls';
	my $query = "INSERT INTO ek_kmet VALUES (?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertObst
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_obst.xls';
	my $query = "INSERT INTO ek_obst VALUES (?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertRaion
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_raion.xls';
	my $query = "INSERT INTO ek_raion VALUES (?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertReg2
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_reg2.xls';
	my $query = "INSERT INTO ek_reg2 VALUES (?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertTsb
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_tsb.xls';
	my $query = "INSERT INTO ek_tsb VALUES (?, ?)";
	insert($_[0], $query, $path);
}

sub insertSobr
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_sobr.xls';
	my $query = "INSERT INTO ek_sobr VALUES (?, ?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertObl
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_obl.xls';
	my $query = "INSERT INTO ek_obl VALUES (?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertSof
{		
	my $path = '/home/stefi/Documents/Ekatte/Sof_rai.xls';
	my $query = "INSERT INTO sof_rai VALUES (?, ?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}

sub insertEkatte
{		
	my $path = '/home/stefi/Documents/Ekatte/Ek_atte.xls';
	my $query = "INSERT INTO ek_atte VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	insert($_[0], $query, $path);
}


sub main
{
	my $dsn = "DBI:Pg:dbname=ekatte;host=127.0.0.1;port=5432";
	my $userid = "postgres";
	my $password = "Imamazing!";
	my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })or die $DBI::errstr;
	print "Opened database successfully\n\n";
	
	
	insertDoc($dbh);
	insertKmet($dbh);
	insertObst($dbh);
	insertRaion($dbh);
	insertReg2($dbh);
	insertTsb($dbh);
	insertSobr($dbh);
	insertObl($dbh);
	insertSof($dbh);
	insertEkatte($dbh);
	
}  

main();
