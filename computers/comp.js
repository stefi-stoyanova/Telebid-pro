



$("#btype").click(function(){
	var text = $("#type").val();
	$("#type").val("");
	insertType(text);
	return false;
});
		
$("#bmodel").click(function(){
	var text = $("#model").val();
	var type = $('#modelType').val();
	$("#model").val("");;
	insertModel(text, type);
	return false;
});

$("#bnetwork").click(function(){
	var text = $("#network").val();
	$("#network").val("");
	insertNetwork(text);
	return false;
});

$("#bcomputer").click(function(){
	var text = $("#computer").val();
	var net = $('#computerNetwork').val();
	$("#computer").val("");
	insertComputer(text, net);
	return false;
});

$("#bdevice").click(function(){
	var number =  $("#deviceSerialNumber").val();
	var text = $("#deviceWarranty").val();
	var net = $('#deviceNetwork').val();
	var model = $('#deviceModel').val();
	$("#deviceWarranty").val("");
	insertDevice(number, net, model, text);
	return false;
});

$("#bpart").click(function(){
	var number =  $("#partSerialNumber").val();
	var text = $("#partWarranty").val();
	var computer = $('#partComputer').val();
	var model = $('#partModel').val();
	$("#partWarranty").val("");
	insertPart(number, computer, model, text);
	return false;
});

$("#bsearch").click(function(){
	var text = $("#search").val();
	searchComputer(text);
	document.getElementById('searchTableDiv').style.display='block';
	return false;
});


$("#mType").click(function(){

	hideAll();
	document.getElementById('formType').style.display='block';
	createTable("getOffsetTypes", "typeTable", 1);
})

$("#mModel").click(function(){
	hideAll();
	document.getElementById('formModel').style.display='block';
	createTable("getOffsetModels", "modelTable",1);
})

$("#mNetwork").click(function(){
	hideAll();
	document.getElementById('formNetwork').style.display='block';
	createTable("getOffsetNetworks", "networkTable",1);
})

$("#mComputer").click(function(){
	hideAll();
	document.getElementById('formComputer').style.display='block';
	createTable("getOffsetComputers", "computerTable",1);
})

$("#mDevice").click(function(){
	hideAll();
	document.getElementById('formDevice').style.display='block';
	createTable("getOffsetDevices", "devicesTable",1);
})

$("#mPart").click(function(){
	hideAll();
	document.getElementById('formPart').style.display='block';
	createTable("getOffsetParts", "partsTable",1);
})

$("#mSearch").click(function(){
	hideAll();
	document.getElementById('searchTableDiv').style.display='none';
	document.getElementById('formSearch').style.display='block';
})

function hideAll()
{
	document.getElementById('formType').style.display='none';
	document.getElementById('formModel').style.display='none';
	document.getElementById('formNetwork').style.display='none';
	document.getElementById('formComputer').style.display='none';
	document.getElementById('formDevice').style.display='none';
	document.getElementById('formPart').style.display='none';
	document.getElementById('formSearch').style.display='none';
}

//get("modelType", "getTypes");
get("computerNetwork", "getNetworks");
get("deviceNetwork", "getNetworks");
get("deviceModel", "getModels");
get("partModel", "getModels");
get("partComputer", "getComputers");
get("search", "getComputers");

function get(field, func)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : func},
		success : function(data)
		{
			if(data == 'Error')
			{
				alert(data);
				return false;
			}
			var res = $.parseJSON(data)
			var x = document.getElementById(field);
			 
			for(var i=x.options.length-1;i>=0;i--)
			{
				x.remove(i);
			}
			var c;

			for(var i=1; i<=res.length; i++)
			{
				c = document.createElement("option");
				if(typeof res[i-1] == "string"){
					c.text = res[i-1];
					
				} else {
					c.text = res[i-1][0];		
				} 
				x.options.add(c, i);
			}
		}

	});
}



function insertType(data)
{
	if(!data)
	{
		alert("This field cannot be empty");
		return;
	}
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertType" , "data" : data },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			//get("modelType", "getTypes");
			createTable("getOffsetTypes", "typeTable",1);
		}
	});
	console.log("insertType");
	
}


function insertModel(model, type )
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertModel", "type" : type, "model" : model },
		dataType : "json",
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			createTable("getOffsetModels", "modelTable",1);
			get("deviceModel", "getModels");
			get("partModel", "getModels");
		}
	});
	console.log("insertModel");
}

function insertNetwork(data)
{
	if(!data)
	{
		alert("This field cannot be empty");
		return;
	}
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertNetwork" , "data" : data },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			get("computerNetwork", "getNetworks");
			get("deviceNetwork", "getNetworks");
			createTable("getOffsetNetworks", "networkTable",1);
		}
	});
	console.log("insertNetwork");
	
}

function insertComputer(name, network)
{
	if(!name)
	{
		alert("This field cannot be empty");
		return;
	}
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertComputer", "name" : name, "network" : network },
		dataType : "json",
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			get("partComputer", "getComputers");
			get("search", "getComputers");
			createTable("getOffsetComputers", "computerTable",1);
		}
	});
	console.log("insertComputer");
}

function insertDevice(number, network, model, warranty)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertDevice", "serial_number": number, "network" : network, "model" : model, "warranty" : warranty },
		dataType : "json",
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			createTable("getOffsetDevices", "devicesTable",1);
		}
	});
	console.log("insertDevice");
}

function insertPart(number, computer, model, warranty)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "insertPart", "serial_number": number, "computer" : computer, "model" : model, "warranty" : warranty },
		dataType : "json",
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}

			createTable("getOffsetParts", "partsTable",1);
		}
	});
	console.log("insertPart");
}

function searchComputer(text)
{

	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "searchComputer", "computer" : text},
		dataType : "json",
		success : function(data) {
			if(data == 'Error')
			{
				alert(data);
				return false;
			}

			//console.log(data);
			if(!data.length)
			{
				document.getElementById('searchTableDiv').style.display='none';
				alert("This computer has no parts!");
				return;
			}
			var str = '';
			var table = document.getElementById("searchTable");

			while(table.getElementsByTagName("tr").length > 1)
			{
				table.deleteRow(1);
			}
			for(var i=0;i<data.length; i++)
			{
				var row = table.insertRow(i+1);
				for(var k=0; k<data[i].length; k++)
				{
					var cell1 = row.insertCell(k);
					cell1.innerHTML = data[i][k];
					
				}
				
			}
			
		}
	});
	console.log("searchComputer");
}


$(document).on("click", "#typeTableNext", function(){
	
	var page = $('#page1').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetTypes', 'typeTable', $('#page1').val());
	return false;
});

$(document).on("click", "#modelTableNext", function(){
	var page = $('#page2').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetModels', 'modelTable', $('#page2').val());
	return false;
});

$(document).on("click", "#networkTableNext", function(){
	var page = $('#page3').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetNetworks', 'networkTable', $('#page3').val());
	return false;
});

$(document).on("click", "#computerTableNext", function(){
	var page = $('#page4').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetComputers', 'computerTable', $('#page4').val());
	return false;
});

$(document).on("click", "#deviceTableNext", function(){
	var page = $('#page5').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetDevices', 'devicesTable', $('#page5').val());
	return false;
});

$(document).on("click", "#partTableNext", function(){
	var page = $('#page6').val();
	if (isNaN(page) || page % 1 != 0 || page < 0)
	{
		alert("Enter valid number");
		return false
	}
	createTable('getOffsetParts', 'partsTable', $('#page6').val());
	return false;
});

function createTable(func, tableName, page)
{

	var rowsPerPage = 20;

	console.log(func);
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : func, "numRows" : rowsPerPage, 'page' : page},
		success : function(data)
		{
			if(data == 'Error' || data == '')
			{
				alert(data);
				return false;
			}
			console.log(data);
			var data = $.parseJSON(data);
			var table = document.getElementById(tableName);
			
			while(table.rows.length > 1)
			{
				table.deleteRow(1);
			}

			var tbody;
			if(table.tBodies.length > 0)
				tbody =  table.tBodies[0];
			else
				tbody = table.appendChild(document.createElement('tbody'));

			
			for(var i in data){
				var row = table.insertRow(table.rows.length);
				tbody.appendChild(row);

				var el=0;
				var id=-1;
				for(var k in data[i]){
					if(el==0)
					{
						id=data[i][k];
						el=1;
						continue;
					}
					var cell = row.insertCell(k-1);
					cell.innerHTML = data[i][k];
				
				}

				var cell1 = row.insertCell(row.cells.length)
				var element = document.createElement("button");
  				element.innerHTML = "Edit";
  				element.id = id
  				element.name = row.cells[0].innerText;
  				element.className = tableName;
   				cell1.appendChild(element);

	   			var cell2 = row.insertCell(row.cells.length)
				var del= document.createElement("button");
	  			del.innerHTML = "Delete";
	  			del.id = id;
	  			del.className ="Del";
	   			cell2.appendChild(del);														
			}			
		}
	});	
}



$(document).on("click", ".Del", function(){
	var id = $(this).attr("id");
	var table = $(this).parent().parent().parent().parent().attr('name');
	deleteRecord(id, table);
	return false;
});

function deleteRecord(id, table)
{
	if (!confirm('Are you sure you want to delete this record?')) {
    	return;
	} 
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "delete", "id" : id, "table" : table},
		success : function(response) {
			if(response == "Error")
			{
				alert("You cannot delete this record.")
				return false;
			}
			createTable("getOffsetTypes", "typeTable", 1);
			createTable("getOffsetParts", "partsTable", 1);
			createTable("getOffsetDevices", "devicesTable", 1);
			createTable("getOffsetComputers", "computerTable", 1);
			createTable("getOffsetNetworks", "networkTable", 1);
			createTable("getOffsetModels", "modelTable", 1);
		}
	});
	console.log("delete");
}



$(document).on("click", ".typeTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	document.getElementById('formUpdateType').style.display='block';
	$("#utype").val(name);
	var rowID = id;

	$("#butype").click(function(){
		var text = $("#utype").val();
		updateType(rowID, text);
		document.getElementById('formUpdateType').style.display='none';
		return false;
	});
	return false;
});


$(document).on("click", ".modelTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	//get("umodelType", "getTypes");
	document.getElementById('formUpdateModel').style.display='block';
	$("#umodel").val(name);
	var rowID = id;

	$("#bumodel").click(function(){
		var model = $("#umodel").val();
		var type = $("#umodelType").val();
		updateModel(rowID, model, type);
		document.getElementById('formUpdateModel').style.display='none';
		return false;
	});
	return false;
});


$(document).on("click", ".networkTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	document.getElementById('formUpdateNetwork').style.display='block';
	$("#unetwork").val(name);
	var rowID = id;

	$("#bunetwork").click(function(){
		var text = $("#unetwork").val();
		updateNetwork(rowID, text);
		document.getElementById('formUpdateNetwork').style.display='none';
		return false;
	});

	return false;
});


$(document).on("click", ".computerTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	get("ucomputerNetwork", "getNetworks");
	document.getElementById('formUpdateComputer').style.display='block';
	$("#ucomputer").val(name);
	var rowID = id;

	$("#bucomputer").click(function(){
		var name = $("#ucomputer").val();
		var net = $("#ucomputerNetwork").val();
		updateComputer(rowID, name, net);
		document.getElementById('formUpdateComputer').style.display='none';
		return false;
	});
	return false;
});


$(document).on("click", ".devicesTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	get("udeviceModel","getModels");
	get("udeviceNetwork", "getNetworks");
	document.getElementById('formUpdateDevice').style.display='block';
	$("#udeviceSerialNumber").val(name);
	var rowID = id;

	$("#budevice").click(function(){
		var number = $("#udeviceSerialNumber").val();
		var warranty = $("#udeviceWarranty").val();
		var model = $("#udeviceModel").val();
		var net = $("#udeviceNetwork").val();
		updateDevice(rowID, number, warranty, model, net);
		document.getElementById('formUpdateDevice').style.display='none';
		return false;
	});
	return false;
});


$(document).on("click", ".partsTable", function(){
	var id = $(this).attr("id");
	var name = $(this).attr("name");
	get("upartModel","getModels");
	get("upartComputer", "getComputers");
	document.getElementById('formUpdatePart').style.display='block';
	$("#upartSerialNumber").val(name);
	var rowID = id;

	$("#bupart").click(function(){
		var number = $("#upartSerialNumber").val();
		var warranty = $("#upartWarranty").val();
		var model = $("#upartModel").val();
		var computer = $("#upartComputer").val();
		updatePart(rowID, number, warranty, model, computer);
		document.getElementById('formUpdatePart').style.display='none';
		return false;
	});

	return false;
});



function updateType(id, text)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updateType", "id" : id, "text" : text },
		dataType : "json",
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			//get("modelType", "getTypes");
			createTable("getOffsetTypes", "typeTable",1);
		}
	});
	console.log("updateType");
}

function updateModel(id, model, type)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updateModel", "id" : id, "model" : model, "type" : type },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			createTable("getOffsetModels", "modelTable",1);
			get("deviceModel", "getModels");
			get("partModel", "getModels");
		}
	});
	console.log("updateModel");
}

function updateNetwork(id, network)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updateNetwork", "id" : id, "text" : network },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			get("computerNetwork", "getNetworks");
			get("deviceNetwork", "getNetworks");
			createTable("getOffsetNetworks", "networkTable",1);
		}
	});
	console.log("updateModel");
}


function updateComputer(id, name, net)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updateComputer", "id" : id, "host_name" : name, "network" : net },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			get("partComputer", "getComputers");
			get("search", "getComputers");
			createTable("getOffsetComputers", "computerTable",1);
		}
	});
	console.log("updateComputer");
}

function updateDevice(id, number, warranty, model, net)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updateDevice", "id" : id, "serial_number" : number, "warranty": warranty, "model": model, "network" : net },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			createTable("getOffsetDevices", "devicesTable",1);	
		}
	});
	console.log("updateDevice");
}

function updatePart(id, number, warranty, model, host_name)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "updatePart", "id" : id, "serial_number" : number, "warranty": warranty, "model": model, "computer" : host_name },
		success : function(response) {
			if(response == 'Error')
			{
				alert(response);
				return false;
			}
			createTable("getOffsetParts", "partsTable",1);	
		}
	});
	console.log("updatePart");
}




$(document).on("click", ".search", function(){
	var name = $('#typeSearch').val();
	searchRecords("types", name);
	return false;
});

function searchRecords(table, text)
{
	$.ajax({
		type: 'POST',
		url: 'computers.pl',
		data: { "choice" : "search", "table" : table , "text" : text},
		success : function(response) {
			alert(response);
		}
	});
}