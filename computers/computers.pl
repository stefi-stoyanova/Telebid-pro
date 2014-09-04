#!/usr/bin/perl -w
use CGI;
use strict;
use DBI;
use warnings;
use utf8;
use JSON;
use Switch;
use Data::Dumper;
use Try::Tiny;
use Encode qw(decode encode);

#use CGI::Session;

print "Content-type: text/html\n\n";

my $updateType = "UPDATE types SET type=? WHERE id=?";
my $updateModel = "UPDATE models SET (model, type_id) = (?, ?) WHERE id=?";
my $updateNetwork = "UPDATE networks SET name=? WHERE id=?";
my $updateComputer = "UPDATE computers SET (host_name, network_id) = (?, ?) WHERE id=?";
my $updateDevice = "UPDATE network_devices SET (serial_number, warranty, model_id, network_id)=(?,?,?,?) WHERE id=?";
my $updatePart = "UPDATE hardware_parts SET (serial_number, warranty, model_id, computer_id)=(?,?,?,?) WHERE id=?";


try
{
	my $q = CGI->new;


	my $dsn = "DBI:Pg:dbname=computers;host=127.0.0.1;port=5432";
	my $userid = "postgres";
	my $password = "Imamazing!";
	my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1})or die $DBI::errstr;


	my $choice = $q->param('choice');

	switch ($choice) {

		case "getTypes"			{ 
			my $searched = $q->param('searched');
			my $getTypes="SELECT type 
							FROM types 
							WHERE type LIKE '%" . $searched . "%' 
							ORDER BY type ASC 
							LIMIT 200";
			get($dbh, $getTypes);}
		case "getOffsetTypes"	{
			my $searched = $q->param('searched');
			my $language = $q->param('language');
			my $rows = $q->param('numRows');
			my $page =($q->param('page')-1)*$rows;
			my $query="SELECT id, type 
						FROM types
						WHERE type LIKE '%" . $searched . "%'
						ORDER BY type ASC 
						LIMIT $rows 
						OFFSET $page";
			get($dbh, $query, $language)}

		case "getNetworks"       { 
			my $searched = $q->param('searched');
			my $getNetworks = "SELECT name 
								FROM networks 
								WHERE name LIKE '%" . $searched . "%' 
								ORDER BY name ASC 
								LIMIT 200";
			get($dbh, $getNetworks); }
		case "getOffsetNetworks"	{
			my $language = $q->param('language');
			my $searched = $q->param('searched');
            $searched = decode('UTF-8', $searched, Encode::FB_CROAK);
            my $name = "name";
            if($language ne 'en')
            {
                $name = $name . "_" . $language;
            } 
			my $rows = $q->param('numRows');
			my $page =($q->param('page')-1)*$rows;
			my $query="SELECT networks.id, $name 
						FROM networks 
						WHERE $name LIKE '%" . $searched . "%' 
						ORDER BY $name ASC 
						LIMIT $rows 
						OFFSET $page";
			get($dbh, $query, $language)}
		
		case "getModels"       { 
			my $searched = $q->param('searched');
			my $getModels = "SELECT model, type 
								FROM models 
								JOIN types ON types.id=models.type_id 
								WHERE model LIKE '%" . $searched . "%' 
								ORDER BY model ASC 
								LIMIT 200";
			get($dbh, $getModels); }
		case "getOffsetModels"	{
			my $language = $q->param('language');
			my $searched = $q->param('searched');
			my $rows = $q->param('numRows');
			my $page =($q->param('page')-1)*$rows;
			my $query="SELECT models.id, model, type 
						FROM models 
						JOIN types ON types.id=models.type_id 
						WHERE model LIKE '%" . $searched . "%'
						ORDER BY model ASC 
						LIMIT $rows
						OFFSET $page";
			get($dbh, $query, $language)}
		
		case "getComputers"       { 
			my $searched = $q->param('searched');
			my $getComputers = "SELECT host_name, name 
								FROM computers 
								JOIN networks ON computers.network_id=networks.id 
								WHERE host_name LIKE '%" . $searched . "%' 
								ORDER BY host_name ASC
								LIMIT 200";
			get($dbh, $getComputers); }
		case "getOffsetComputers"	{
            my $searched = $q->param('searched');
            $searched = decode('UTF-8', $searched, Encode::FB_CROAK);
			my $language = $q->param('language');
			my $host_name = "host_name";
            my $name = "name";
			if($language ne 'en')
			{
                $name = $name . "_" .  $language;
				$host_name = $host_name . "_" . $language;
			} 

            my $rows = $q->param('numRows');
            my $page =($q->param('page')-1)*$rows;
            my $query="SELECT computers.id, $host_name, $name 
                        FROM computers 
                        JOIN networks ON computers.network_id=networks.id  
                        WHERE $host_name LIKE '%" . $searched . "%'
                        ORDER BY $host_name ASC  
                        LIMIT $rows 
                        OFFSET $page";
			get($dbh, $query, $language)}
		
		case "getOffsetDevices"	{
			my $language = $q->param('language');
			my $searched = $q->param('searched');
            my $name = "networks.name";
            if($language ne 'en')
            {
                $name = $name . "_" . $language;
            } 

			my $rows = $q->param('numRows');
			my $page =($q->param('page')-1)*$rows;
			my $query="SELECT network_devices.id, serial_number, warranty, model, $name 
						FROM network_devices
						JOIN models ON models.id = network_devices.model_id
						JOIN networks ON networks.id = network_devices.network_id  
						WHERE serial_number LIKE '%" . $searched . "%'
						ORDER BY serial_number ASC 
						LIMIT $rows 
						OFFSET $page";
			get($dbh, $query, $language)}

		case "getOffsetParts"	{
			my $language = $q->param('language');
			my $searched = $q->param('searched');
                    my $host_name = "host_name";
            if($language ne 'en')
            {
                $host_name = $host_name . "_" . $language;
            } 
			my $rows = $q->param('numRows');
			my $page =($q->param('page')-1)*$rows;
			my $query="SELECT hardware_parts.id, serial_number, warranty, model, $host_name 
						FROM hardware_parts
						JOIN models ON models.id = hardware_parts.model_id
						JOIN computers ON computers.id = hardware_parts.computer_id  
						WHERE serial_number LIKE '%" . $searched . "%'
						ORDER BY serial_number ASC 
						LIMIT $rows 
						OFFSET $page";
			get($dbh, $query, $language)}

		case "updateType"	{updateType($dbh, $updateType, $q->param('text'), $q->param('id'))}
		case "updateModel"	{updateModel($dbh, $updateModel, $q->param('model'), $q->param('type'), $q->param('id'))}
		case "updateNetwork"	{updateNetwork($dbh, $updateNetwork, $q->param('text'), $q->param('id'))}
		case "updateComputer"	{updateComputer($dbh, $updateComputer, $q->param('host_name'), $q->param('network'), $q->param('id'))}
		case "updateDevice"	{updateDevice($dbh, $updateDevice, $q->param('serial_number'),$q->param('warranty'),$q->param('model'), $q->param('network'), $q->param('id'))}
		case "updatePart"	{updatePart($dbh, $updatePart, $q->param('serial_number'), $q->param('warranty'),$q->param('model'),$q->param('computer'), $q->param('id'))}
		
		case "insertType"		{ insertType($dbh, $q->param('data'))}
	 	case "insertModel"   	{ insertModel($dbh,$q->param('type'), $q->param('model'));}
	 	case "insertNetwork"	{ insertNetwork($dbh, $q->param('data')); }
	 	case "insertComputer"   	{ insertComputer($dbh,$q->param('name'), $q->param('network'));}
	 	case "insertDevice"   	{ insertDevice($dbh,$q->param('network'), $q->param('serial_number'), $q->param('model'), $q->param('warranty') );}
	 	case "insertPart"   	{ insertPart($dbh,$q->param('computer'), $q->param('serial_number'), $q->param('model'), $q->param('warranty') );}
	 	
	 	case "delete"	{del($dbh, $q->param('id'), $q->param('table'))}

	 	case "searchComputer"       { 
	 		my $name = $q->param('computer');
	 		my $searchComputer = "SELECT serial_number, model, type, warranty 
	 								FROM parts 
									JOIN computers ON computers.id = parts.computer_id
									WHERE computers.host_name = '$name';";
			get($dbh, $searchComputer); }

		case "search"  {search($dbh, $q->param('table'), $q->param('text'))}
		case "getPermissions" {getPermissions($dbh, $q->param('user'))}
	}
#}


	sub getPermissions($$)
	{
		my ($dbh, $user) = @_;

		my $sth;
		try
		{
			$sth = $dbh->prepare("SELECT permissions FROM users WHERE username = ?");
			$sth->execute($user);
			print $sth->fetchrow_array();
		}
		catch
		{
	   		print "Error";
	   	}

	}

	sub search($$$)
	{
		my ($dbh, $table, $text) = @_;

		my $sth;
		try
		{
			$sth = $dbh->prepare("SELECT * FROM $table WHERE type LIKE \'%" + $text + "%\'");
			$sth->execute();
		}
		catch
		{
	   		print "Error";
	   		return;
	   	}

	   	my @rows;
		my $i=0;
		my @row;
		while (@row = $sth->fetchrow_array() )
		{
			my $size = @row;
			for(my $k=0; $k<$size; $k++)
			{
			
				
				$rows[$i][$k] = $row[$k];
			}
			$i++;
		}

		my $json = new JSON;
		print $json->encode(\@rows);
	}


	sub del($$$) 
	{
		
		my ($dbh, $id, $table) = @_;	
		
		try
		{
			my $sth = $dbh->prepare("DELETE FROM $table WHERE id=?");
			$sth->execute($id);# or die "DBI::errstr";
		}
		catch
		{
	   		print "You cannot delete this record.";
	   		return;
	   	}
	}

	sub get($$)
	{
		my ($dbh, $query, $language) = @_;

		my $sth;
		try
		{
			$sth = $dbh->prepare($query) or return undef;
			$sth->execute() or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   		return;
	   	}

		my @rows ;
		my $i=0;
		my @row;

		if($language)
		{
			$i++;
			my $l=0;
			my @names = @{$sth->{NAME}};
			foreach my $name (@names){
				try
				{
					my $sth1 = $dbh->prepare("SELECT $language FROM meta_data WHERE column_name = ?") or return undef;
					$sth1->execute($name) or die "DBI::errstr";
		    		
		    		$rows[0][$l] = $sth1->fetchrow_array();
		    		$l++;
				}
				catch
				{
			   		print "Error";
			   		return;
			   	}
		   	}
		}	

		#my $names = $sth->{NAME};
		#push (@rows, $names); 
		
		while (@row = $sth->fetchrow_array() )
		{
			#push(@rows, \@row);
			my $size = @row;
			for(my $k=0; $k<$size; $k++)
			{
			
				
				$rows[$i][$k] = $row[$k];
			}
			$i++;
		}

		my $json = new JSON;
		print $json->encode(\@rows);
		
	}

	sub updateType($$$$)
	{
		my ($dbh, $query, $type, $id) = @_;

		try
		{
			$dbh->do($query, undef, $type, $id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
	}

	sub updateModel($$$$$)
	{
		my ($dbh, $query, $model, $type, $id) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM types WHERE type = '$type'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $type_id = $sth->fetchrow_array();

			$dbh->do($query, undef, $model, $type_id, $id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub updateNetwork($$$$)
	{
		my ($dbh, $query, $network, $id) = @_;

		try
		{
			$dbh->do($query, undef, $network, $id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
	}

	sub updateComputer($$$$$)
	{
		my ($dbh, $query, $name, $net, $id) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM networks WHERE name = '$net'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $network_id = $sth->fetchrow_array();

			$dbh->do($query, undef, $name, $network_id, $id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
	}

	sub updateDevice($$$$$$$)
	{

		my ($dbh, $query, $number, $warranty, $model, $net, $id) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM networks WHERE name = '$net'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $network_id = $sth->fetchrow_array();
				
			$sth = $dbh->prepare("SELECT id FROM models WHERE model = '$model'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $model_id = $sth->fetchrow_array();

			if($warranty eq '')
			{
			$query ="UPDATE network_devices SET (serial_number, model_id, network_id)=(?,?,?) WHERE id=?"; ;
					$dbh->do($query, undef, $number, $model_id, $network_id, $id) or die "DBI::errstr";
			} else {
				$dbh->do($query, undef, $number, $warranty, $model_id, $network_id, $id) or die "DBI::errstr";
			}
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub updatePart($$$$$$$)
	{
		my ($dbh, $query, $number, $warranty, $model, $computer, $id) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM computers WHERE host_name = '$computer'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $computer_id = $sth->fetchrow_array();

			$sth = $dbh->prepare("SELECT id FROM models WHERE model = '$model'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $model_id = $sth->fetchrow_array();

			if($warranty eq ''){
				$query ="UPDATE hardware_parts SET (serial_number, model_id, computer_id)=(?,?,?) WHERE id=?"; ;
				$dbh->do($query, undef, $number, $model_id, $computer_id, $id) or die "DBI::errstr";
			} else {
				$dbh->do($query, undef, $number, $warranty, $model_id, $computer_id, $id) or die "DBI::errstr";
			}
		}
		catch
		{
	   		print "Error";
	   	}
		
		
	}

	sub insertType($$)
	{
		my ($dbh, $type) = @_;

		try
		{
			$dbh->do("INSERT INTO types (type) VALUES (?)", undef, $type) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub insertModel($$$)
	{
		my ($dbh, $type, $model) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM types WHERE type = '$type'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $type_id = $sth->fetchrow_array();

			$dbh->do("INSERT INTO models (model, type_id) VALUES (?, ?)", undef, $model, $type_id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub insertNetwork($)
	{
		my ($dbh, $network) = @_;
		try
		{
			$dbh->do("INSERT INTO networks (name) VALUES (?)", undef, $network) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub insertComputer($$$)
	{
		my ($dbh, $name, $network) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM networks WHERE name = '$network'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $network_id = $sth->fetchrow_array();

			$dbh->do("INSERT INTO computers (host_name, network_id) VALUES (?, ?)", undef, $name, $network_id) or die "DBI::errstr";
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub insertDevice($$$$$)
	{
		my ($dbh, $network, $serial_number, $model, $warranty) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM networks WHERE name = '$network'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $network_id = $sth->fetchrow_array();

			$sth = $dbh->prepare("SELECT id FROM models WHERE model = '$model'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $model_id = $sth->fetchrow_array();
			if ($warranty eq '')
			{
				$dbh->do("INSERT INTO network_devices (serial_number, network_id, model_id) VALUES (?, ?, ?)", undef, $serial_number,	 $network_id, $model_id) or die "DBI::errstr";
			} else {
				$dbh->do("INSERT INTO network_devices (serial_number, network_id, model_id, warranty) VALUES (?, ?, ?, ?)", undef, $serial_number,	 $network_id, $model_id, $warranty) or die "DBI::errstr";
			}	
		}
		catch
		{
	   		print "Error";
	   	}
		
	}

	sub insertPart($$$$$)
	{
		my ($dbh, $computer, $serial_number, $model, $warranty) = @_;

		try
		{
			my $sth = $dbh->prepare("SELECT id FROM computers WHERE host_name = '$computer'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $computer_id = $sth->fetchrow_array();

			$sth = $dbh->prepare("SELECT id FROM models WHERE model = '$model'") or return undef;
			$sth->execute() or die "DBI::errstr";
			my $model_id = $sth->fetchrow_array();

			if($warranty eq ''){
				$dbh->do("INSERT INTO hardware_parts (serial_number, computer_id, model_id) VALUES (?, ?, ?)", undef, $serial_number, $computer_id, $model_id) or die "DBI::errstr";
			} else {
				$dbh->do("INSERT INTO hardware_parts (serial_number, computer_id, model_id, warranty) VALUES (?, ?, ?, ?)", undef, $serial_number, $computer_id, $model_id, $warranty) or die "DBI::errstr";
			}
		}
		catch
		{
	   		print "Error";
	   	}
	}
} 
catch
{
	print "Unexpected error";
}

