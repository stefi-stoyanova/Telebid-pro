(function() {


$.i18n().load( {
    'en': {             
            'hello' : 'Hello',
            'notloggedin' : "You are not logged in.",
            'notempty' : 'This field cannot be empty.',
            'record-exists' : 'This record alredy exists.',
            'unexpected-error' : 'There is unexpected error.',
            'edit' : 'Edit',
            'delete' : 'Delete',
            'confirm-delete' : 'Are you sure you want to delete this record?',
            'cant-delete' : 'You cannot delete this record.',
            'types' : 'Types',
            'models' : 'Models',
            'networks' : 'Networks',
            'computers' : 'Computers',
            'parts' : 'Hardware parts',
            'devices' : 'Network devices',
            'search' : 'Search',
            'logout' : 'Log out',
            'profile' : 'Profile',
            'save' : 'Save',
            'add' : 'Add',
            'warranty' : 'Warranty',
            'type' : 'Type',
            'model' : 'Model',
            'network' : 'Network',
            'computer' : 'Computer name',
            'serial-number': 'Serial number'
        }, 

    'bg': {             
            'hello' : 'Здравей',
            'notloggedin' : "Не сте в акаунта си.",
            'notempty' : 'Това поле не може да бъде празно.',
            'record-exists' : 'Този запис вече съществува.',
            'unexpected-error' : 'Възникна неочаквана грешка.',
            'edit' : 'Редактирай',
            'delete' : 'Изтрий',
            'confirm-delete' : 'Сигурни ли сте, че искате да изтриете този запис?',
            'cant-delete' : 'Не можете да изтриете този запис.',
            'types' : 'Типове',
            'models' : 'Модели',
            'networks' : 'Мрежи',
            'computers' : 'Компютри',
            'parts' : 'Хардуерни части',
            'devices' : 'Мрежови устройства',
            'search' : 'Търсене',
            'logout' : 'Изход',
            'profile' : 'Профил',
            'save' : 'Запази',
            'add' : 'Добави',
            'warranty' : 'Гаранция',
            'type' : 'Тип',
            'model' : 'Модел',
            'network' : 'Мрежа',
            'computer' : 'Име на компютъра',
            'serial-number': 'Сериен номер'
        }, 
});


$.i18n({
        locale: getCookie("language")
});


$(function(){

    var r = sendRequest('computers.pl', {'choice' : "getPermissions", 'user' : getCookie("loggedin")});
    r.done(function(response) {
        if(response == 'r')
        {
            $("button.write").attr("disabled", true);
                                                                       
        }
                      
    });

});

var name = document.createTextNode($.i18n('hello') +", " + getCookie("loggedin") + "!");
var span = document.getElementById("username");
span.appendChild(name);

$('#mType').html($.i18n('types'));
$('#mModel').html($.i18n('models'));
$('#mNetwork').html($.i18n('networks'));
$('#mDevice').html($.i18n('devices'));
$('#mPart').html($.i18n('parts'));
$('#mComputer').html($.i18n('computers'));
$('#mSearch').html($.i18n('search'));
$('#logout').html($.i18n('logout'));
$('#profile').html($.i18n('profile'));
$('.save').html($.i18n('save'));
$('.search').html($.i18n('search'));
$('.searchTable').html($.i18n('search'));
$('.add').html($.i18n('add'));
$('.warranty').html($.i18n('warranty'));
$('.update').html($.i18n('edit'));

$('.type').val($.i18n('type'));
$('.model').val($.i18n('model'));
$('.network1').val($.i18n('network'));
$('.computer').val($.i18n('computer'));
$('.searchTableText').val($.i18n('search'));
$('.serialnumber').val($.i18n('serial-number'));


$("#profile").click(function(){
    hideAll();
    $("#userInfo").show();
});


$("input[type='number']").bind("input", function() {
    createTable($(this).next().next().attr('id'), $(this).val(), $('.searchTableText', $(this).parent()).val());
});

$(".searchTable").click(function(){
    
    var val= $('.searchTableText', $(this).parent()).val();
    var table = $('table', $(this).parent()).attr('id');
    var page = $('.page', $(this).parent()).val();
    $('.tables',  $(this).parent()).show();
    $('.page',  $(this).parent()).show();
    createTable(table, page , val);
    
    return false;
});

$(".search").click(function(){

    var select = $('.select', $(this).parent())
    select.show();
    var id=select.attr('id');
    var name = select.attr('name');
    var val= $('.searchedText', $(this).parent()).val();
    get(id, name, val);

    $(document).on("click", '.select', function(){
        var val = $(this).val();
        $('.searchedText',$(this).parent()).val(val);
    });
    
    return false;
});


$("input:text").each(function ()
{
    var v = this.value;
    this.style.color = '#B2B2B2';
    $(this).blur(function ()
    {
        if (this.value.length == 0) 
        {
            this.value = v;
            this.style.color = '#B2B2B2';
        }
    }).focus(function ()
    {
        this.value = "";
        this.style.color = '#000000';
    }); 
});


if(!getCookie("language"))
{
    setCookie("language", $('#language').val(), 1);
} 
else
{
    $("#language").val(getCookie('language'));
}


$("#language").click(function(){
    if(!getCookie("language"))
    {
        setCookie("language", $(this).val(), 1);
    }
    else
    {
        document.cookie = "language=" + $(this).val() + ";";
    }
    window.open ('computers.html','_self',false);
});


function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
    }
    return "";
}

function checkCookie(cname) {
    var user = getCookie(cname);
    if (user != "") {

    } else {
        alert($.i18n('notloggedin'));
        window.open ('index.html','_self',false);
    }
}

checkCookie("loggedin");


$(document).on("click", "button", function(){
    checkCookie("loggedin");
});


$("#btype").click(function(){
    var text = $("#type").val();
    if(text=="")
    {
        alert($.i18n("notempty"));
        return false;
    }
    $("#type").val("");
    insertType(text);
    return false;
});
        
$("#bmodel").click(function(){
    var text = $("#model").val();
    if (text=='')
    {
        alert($.i18n("notempty"));
        return false;
    }
    
    var type = $('.searchedText', $(this).parent()).val();
    $('.searchedText', $(this).parent()).val("");
    $('.select', $(this).parent()).hide();
    $("#model").val("");
    insertModel(text, type);
    return false;
});

$("#bnetwork").click(function(){
    var text = $("#network").val();
    if(text=="")
    {
        alert($.i18n("notempty"));
        return false;
    }
    $("#network").val("");
    insertNetwork(text);
    return false;
});

$("#bcomputer").click(function(){
    var text = $("#computer").val();
    if (text=='')
    {
        alert($.i18n("notempty"));
        return false;
    }

    var net = $('.searchedText', $(this).parent()).val();
    $("#computer").val("");
    $('.searchedText', $(this).parent()).val("");
    $('.select', $(this).parent()).hide();
    insertComputer(text, net);
    return false;
});

$("#bdevice").click(function(){
    var number =  $("#deviceSerialNumber").val();
    var text = $("#deviceWarranty").val();
    var net = $('#deviceNetwork').val();
    var model = $('#deviceModel').val();
    
    $("#deviceSerialNumber").val("");
    $("#deviceWarranty").val("");
    $('#deviceNetwork').val("");
    $('#deviceModel').val("");

    $('.select', $(this).parent()).hide();
    insertDevice(number, net, model, text);
    return false;
});

$("#bpart").click(function(){
    var number =  $("#partSerialNumber").val();
    var text = $("#partWarranty").val();
    var computer = $('#partComputer').val();
    var model = $('#partModel').val();

    $("#partSerialNumber").val("");
    $("#partWarranty").val("");
    $('#partComputer').val("");
    $('#partModel').val("");

    $('.select', $(this).parent()).hide();
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
    //createTable("typeTable", 1);
})

$("#mModel").click(function(){
    hideAll();
    document.getElementById('formModel').style.display='block';
    //createTable( "modelTable",1);
})

$("#mNetwork").click(function(){
    hideAll();
    document.getElementById('formNetwork').style.display='block';
    //createTable("networkTable",1);
})

$("#mComputer").click(function(){
    hideAll();
    document.getElementById('formComputer').style.display='block';
    //createTable( "computerTable",1);
})

$("#mDevice").click(function(){
    hideAll();
    document.getElementById('formDevice').style.display='block';
    //createTable( "devicesTable",1);
})

$("#mPart").click(function(){
    hideAll();
    document.getElementById('formPart').style.display='block';
    //createTable( "partsTable",1);
})

$("#mSearch").click(function(){
    hideAll();
    document.getElementById('searchTableDiv').style.display='none';
    document.getElementById('formSearch').style.display='block';
})

$("#logout").click(function(){
    logout();
})

function logout()
{
    console.log("logging out");
    
    var obj =sendRequest('computers.pl', '');
    obj.done(function(response) {
        document.cookie = "loggedin=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
            window.open ('index.html','_self',false);
    });
}


function hideAll()
{
    $("#userInfo").hide();
    $("#formType").hide();
    $("#formModel").hide();
    $("#formNetwork").hide();
    $("#formComputer").hide();
    $("#formDevice").hide();
    $("#formPart").hide();
    $("#formSearch").hide();
    $("#formUpdateType").hide();
    $("#formUpdateModel").hide();
    $("#formUpdateNetwork").hide();
    $("#formUpdateComputer").hide();
    $("#formUpdateDevice").hide();
    $("#formUpdatePart").hide();

}


function get(field, func, searched)
{
    var data = { "choice" : func, "searched" : searched};
    var obj = sendRequest('computers.pl', data);
    obj.done(function(data) {
        console.log(data);
        var res = $.parseJSON(data)
            var x = document.getElementById(field);
            //var x = field;
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
    });
}

function sendRequest(url, data)
{
    var obj = $.ajax({
            type: 'POST',
            url: url,
            data: data,
            success: function(response){
                if(response == 'Error')
                    alert($.i18n('record-exists'));
            },
            error : function() {
                alert($.i18n('unexpected-error'));
            }
        });
    return obj;
}

function insertType(data)
{
    var data = { "choice" : "insertType" , "data" : data }
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        //createTable( "typeTable",1);
    });
}


function insertModel(model, type )
{
    var data = { "choice" : "insertModel", "type" : type, "model" : model };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
       // createTable( "modelTable",1);
    });
}

function insertNetwork(data)
{
    if(!data)
    {
        alert($.i18n("notempty"));
        return;
    }

    var data = { "choice" : "insertNetwork" , "data" : data };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        //createTable("networkTable",1);
    });
}

function insertComputer(name, network)
{
    if(!name)
    {
        alert($.i18n("notempty"));
        return;
    }

    var data = { "choice" : "insertComputer", "name" : name, "network" : network };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        //createTable("computerTable",1);
    });
}

function insertDevice(number, network, model, warranty)
{
    var data =  { "choice" : "insertDevice", "serial_number": number, "network" : network, "model" : model, "warranty" : warranty };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        //createTable( "devicesTable",1);
    });
}

function insertPart(number, computer, model, warranty)
{
    var data =  { "choice" : "insertPart", "serial_number": number, "computer" : computer, "model" : model, "warranty" : warranty };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        //createTable("devicesTable",1);
    });
}

function searchComputer(text)
{
    var data =  { "choice" : "searchComputer", "computer" : text};
    var obj = sendRequest('computers.pl', data);
    obj.done(function(data) {
        if(!data.length)
            {
                document.getElementById('searchTableDiv').style.display='none';
                //alert("This computer has no parts!");
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
    });

    
    console.log("searchComputer");
}



function createTable(tableName, page, val)
{

    var rowsPerPage = 20;

    var func;
    switch(tableName) {
    case "typeTable":
        func = "getOffsetTypes";
        break;
    case "modelTable":
        func = "getOffsetModels";
        break;
    case "networkTable":
        func = "getOffsetNetworks";
        break;
    case "computerTable":
        func = "getOffsetComputers";
        break;
    case "devicesTable":
        func = "getOffsetDevices";
        break;
    case "partsTable":
        func = "getOffsetParts";
        break;
    }

    var data =  { "choice" : func, "numRows" : rowsPerPage, 'page' : page, 'searched' : val, 'language' : $('#language').val()};
    var obj =sendRequest('computers.pl', data);
    obj.done(function(data) {
        console.log(data);
        var data = $.parseJSON(data);
        var table = document.getElementById(tableName);
        
        table.innerHTML = "";  
               

        var perm = 'r';
        var r = sendRequest('computers.pl', {'choice' : "getPermissions", 'user' : getCookie("loggedin")});
        r.done(function(response) {
            perm = response;

            var tbody = table.appendChild(document.createElement('tbody'));
            for(var i in data){
                var row = table.insertRow(table.rows.length);
                tbody.appendChild(row);
                if(i==0)
                    row.style.background = "AFE7FC";

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


                if(perm == 'w' && i!=0)
                {
                    var cell1 = row.insertCell(row.cells.length)
                    var element = document.createElement("button");
                    element.innerHTML = $.i18n('edit');
                    element.id = id
                    element.name = row.cells[0].innerText;
                    element.className = tableName;
                    cell1.appendChild(element);

                    var cell2 = row.insertCell(row.cells.length)
                    var del= document.createElement("button");
                    del.innerHTML = $.i18n('delete');
                    del.id = id;
                    del.className ="Del";
                    cell2.appendChild(del);                                                      
                }
            }           
        });

                
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
    if (!confirm($.i18n('confirm-delete'))) {
        return;
    } 

    var data = { "choice" : "delete", "id" : id, "table" : table};
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        if(response == "You cannot delete this record.")
        {
            alert($.i18n('cant-delete'));
            return false;
        }
        createTable("typeTable", 1);
        createTable("partsTable", 1);
        createTable("devicesTable", 1);
        createTable("computerTable", 1);
        createTable("networkTable", 1);
        createTable("modelTable", 1);
    });
    console.log("delete");
}


var rowID=-1;
$(document).on("click", ".typeTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");
    $('#formUpdateType').show();
    $("#utype").val(name);
    rowID = id;

    return false;
});

$("#butype").click(function(){
        var text = $("#utype").val();
        updateType(rowID, text);
        document.getElementById('formUpdateType').style.display='none';
        return false;
    });


$(document).on("click", ".modelTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");
    document.getElementById('formUpdateModel').style.display='block';
    $("#umodel").val(name);
    rowID = id;
    return false;
});

$("#bumodel").click(function(){
        var model = $("#umodel").val();
        if (model=='')
        {
            alert($.i18n("notempty"));
            return false;
        }
        
        var type = $('.searchedText', $(this).parent()).val();
        $('.searchedText', $(this).parent()).val("");
        $('.select', $(this).parent()).hide();
        $("#model").val("");
        updateModel(rowID, model, type);
        document.getElementById('formUpdateModel').style.display='none';
        return false;
    });


$(document).on("click", ".networkTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");
    document.getElementById('formUpdateNetwork').style.display='block';
    $("#unetwork").val(name);
    rowID = id;
    return false;
});

$("#bunetwork").click(function(){
        var text = $("#unetwork").val();
        updateNetwork(rowID, text);
        document.getElementById('formUpdateNetwork').style.display='none';
        return false;
    });



$(document).on("click", ".computerTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");
    document.getElementById('formUpdateComputer').style.display='block';
    $("#ucomputer").val(name);
    rowID = id;
    return false;
});

$("#bucomputer").click(function(){
        var name = $("#ucomputer").val();
        if (name=='')
        {
            alert($.i18n("notempty"));
            return false;
        }

        var net = $('.searchedText', $(this).parent()).val();
        $("#computer").val("");
        $('.searchedText', $(this).parent()).val("");
        $('.select', $(this).parent()).hide();

        updateComputer(rowID, name, net);
        document.getElementById('formUpdateComputer').style.display='none';
        return false;
    });


$(document).on("click", ".devicesTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");
    document.getElementById('formUpdateDevice').style.display='block';
    $("#udeviceSerialNumber").val(name);
    rowID = id;
    return false;
});

$("#budevice").click(function(){
        var number = $("#udeviceSerialNumber").val();
        var warranty = $("#udeviceWarranty").val();
        var model = $("#udeviceModel").val();
        var net = $("#udeviceNetwork").val();

        $("#udeviceSerialNumber").val("");
        $("#udeviceWarranty").val("");
        $("#udeviceModel").val("");
        $("#udeviceNetwork").val("");
        $('.select', $(this).parent()).hide();
        updateDevice(rowID, number, warranty, model, net);
        document.getElementById('formUpdateDevice').style.display='none';
        return false;
    });


$(document).on("click", ".partsTable", function(){
    var id = $(this).attr("id");
    var name = $(this).attr("name");

    $("#formUpdatePart").show();
    $("#upartSerialNumber").val(name);
    rowID = id;
    return false;
});

$("#bupart").click(function(){
        var number = $("#upartSerialNumber").val();
        var warranty = $("#upartWarranty").val();
        var model = $("#upartModel").val();
        var computer = $("#upartComputer").val();

        $("#upartSerialNumber").val("");
        $("#upartWarranty").val("");
        $("#upartModel").val("");
        $("#upartComputer").val("");

        $('.select', $(this).parent()).hide();
        updatePart(rowID, number, warranty, model, computer);
        
        $("#formUpdatePart").hide();
        return false;
    });




function updateType(id, text)
{
    var data =  { "choice" : "updateType", "id" : id, "text" : text };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        console.log("here");
        createTable( "typeTable", 1, $('.searchTableText', $('#formType')).val());
    });
}

function updateModel(id, model, type)
{
    var data = { "choice" : "updateModel", "id" : id, "model" : model, "type" : type };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        createTable( "modelTable", 1, $('.searchTableText', $('#formModel')).val());
    });
}

function updateNetwork(id, network)
{
    var data =  { "choice" : "updateNetwork", "id" : id, "text" : network };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        createTable( "networkTable",1, $('.searchTableText', $('#formNetwork')).val());
    });
}


function updateComputer(id, name, net)
{
    var data = { "choice" : "updateComputer", "id" : id, "host_name" : name, "network" : net };
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        createTable( "typeTable",1, $('.searchTableText', $('#formComputer')).val());
    });
}

function updateDevice(id, number, warranty, model, net)
{
    var data = { "choice" : "updateDevice", "id" : id, "serial_number" : number, "warranty": warranty, "model": model, "network" : net }
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
        createTable( "typeTable",1, $('.searchTableText', $('#formDevice')).val());
    });
}

function updatePart(id, number, warranty, model, host_name)
{
    var data = { "choice" : "updatePart", "id" : id, "serial_number" : number, "warranty": warranty, "model": model, "computer" : host_name }
    var obj =sendRequest('computers.pl', data);
    obj.done(function(response) {
       createTable( "typeTable",1, $('.searchTableText', $('#formPart')).val());
    });
}


$(document).on("click", ".search1", function(){
    var name = $('#typeSearch').val();
    searchRecords("types", name);
    return false;
});

function searchRecords(table, text)
{
    var data = { "choice" : "search", "table" : table , "text" : text};
    var obj =sendRequest('computers.pl', data);
}

}) ()
