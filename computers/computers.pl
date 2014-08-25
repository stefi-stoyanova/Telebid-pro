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

print "Content-type: text/html\n\n";


my $getTypes="SELECT type FROM types ORDER BY type ASC";
my $getIdTypes="SELECT id, type FROM types ORDER BY type ASC";

my $getNetworks = "SELECT name FROM networks ORDER BY name ASC";
my $getIdNetworks = "SELECT networks.id, name FROM networks ORDER BY name ASC";

my $getModels = "SELECT model, type FROM models JOIN types ON types.id=models.type_id ORDER BY model ASC";
my $getIdModels = "SELECT models.id, model, type FROM models JOIN types ON types.id=models.type_id ORDER BY model ASC";

my $getComputers = "SELECT host_name, name FROM computers JOIN networks ON computers.network_id=networks.id  ORDER BY host_name ASC";
my $getIdComputers = "SELECT computers.id, host_name, name FROM computers JOIN networks ON computers.network_id=networks.id  ORDER BY host_name ASC";

my $getIdDevices = "SELECT network_devices.id, serial_number, warranty, model, networks.name FROM network_devices
					JOIN models ON models.id = network_devices.model_id
					JOIN networks ON networks.id = network_devices.network_id  ORDER BY model ASC;";

my $getIdParts = "SELECT hardware_parts.id, serial_number, warranty, model, host_name FROM hardware_parts
				JOIN models ON models.id = hardware_parts.model_id
				JOIN computers ON computers.id = hardware_parts.computer_id  ORDER BY model ASC;";

my $updateType = "UPDATE types SET type=? WHERE id=?";
my $updateModel = "UPDATE models SET (model, type_id) = (?, ?) WHERE id=?";
my $updateNetwork = "UPDATE networks SET name=? WHERE id=?";
my $updateComputer = "UPDATE computers SET (host_name, network_id) = (?, ?) WHERE id=?";
my $updateDevice = "UPDATE network_devices SET (serial_number, warranty, model_id, network_id)=(?,?,?,?) WHERE id=?";
my $updatePart = "UPDATE hardware_parts SET (serial_number, warranty, model_id, computer_id)=(?,?,?,?) WHERE id=?";

my $q = CGI->new;

my $dsn = "DBI:Pg:dbname=computers;host=127.0.0.1;port=5432";
my $userid = "postgres";
my $password = "Imamazing!";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1})or die $DBI::errstr;


my $choice = $q->param('choice');


switch ($choice) {

	case "getTypes"			{ get($dbh, $getTypes);}
	case "getIdTypes"		{get($dbh, $getIdTypes)};
	case "getOffsetTypes"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT id, type FROM types ORDER BY type ASC LIMIT $rows OFFSET $page";
		get($dbh, $query)}

	case "getNetworks"       { get($dbh, $getNetworks); }
	case "getIdNetworks"       { get($dbh, $getIdNetworks); }
	case "getOffsetNetworks"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT networks.id, name FROM networks ORDER BY name ASC LIMIT $rows OFFSET $page";
		get($dbh, $query)}
	
	case "getModels"       { get($dbh, $getModels); }
	case "getIdModels"       { get($dbh, $getIdModels); }
	case "getOffsetModels"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT models.id, model, type FROM models JOIN types ON types.id=models.type_id ORDER BY model ASC LIMIT $rows OFFSET $page";
		get($dbh, $query)}
	
	case "getComputers"       { get($dbh, $getComputers); }
	case "getIdComputers"       { get($dbh, $getIdComputers); }
	case "getOffsetComputers"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT computers.id, host_name, name FROM computers JOIN networks ON computers.network_id=networks.id  ORDER BY host_name ASC  LIMIT $rows OFFSET $page";
		get($dbh, $query)}
	
	case "getIdDevices"       { get($dbh, $getIdDevices); }
	case "getOffsetDevices"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT network_devices.id, serial_number, warranty, model, networks.name FROM network_devices
					JOIN models ON models.id = network_devices.model_id
					JOIN networks ON networks.id = network_devices.network_id  ORDER BY serial_number ASC LIMIT $rows OFFSET $page";
		get($dbh, $query)}


	case "getIdParts"       { get($dbh, $getIdParts); }
	case "getOffsetParts"	{
		my $rows = $q->param('numRows');
		my $page =($q->param('page')-1)*$rows;
		my $query="SELECT hardware_parts.id, serial_number, warranty, model, host_name FROM hardware_parts
				JOIN models ON models.id = hardware_parts.model_id
				JOIN computers ON computers.id = hardware_parts.computer_id  ORDER BY serial_number ASC LIMIT $rows OFFSET $page";
		get($dbh, $query)}

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
 		my $searchComputer = "SELECT serial_number, model, type, warranty FROM parts 
				JOIN computers ON computers.id = parts.computer_id
				WHERE computers.host_name = '$name';";
		get($dbh, $searchComputer); }

	case "search"  {search($dbh, $q->param('table'), $q->param('text'))}
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
   		print "Error";
   		return;
   	}
}

sub get($$)
{
	my ($dbh, $query) = @_;

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

	my @models;
	my $i=0;
	my @model;
	while (@model = $sth->fetchrow_array() )
	{
		my $size = @model;
		for(my $k=0; $k<$size; $k++)
		{
		
			
			$models[$i][$k] = $model[$k];
		}
		$i++;
	}

	my $json = new JSON;
	print $json->encode(\@models);
	
}

sub updateType($$$$)
{

	try
	{
		my ($dbh, $query, $type, $id) = @_;
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

