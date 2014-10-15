require(["dijit/Toolbar", 
        "dijit/Declaration", 
        "dijit/form/Button", 
        "dijit/Dialog", 
        "dijit/form/TextBox",
        "dijit/form/Select",
        "dijit/form/Textarea",
        "dijit/form/Form",
        "dojo/_base/connect",
        "dojo/NodeList-traverse",
        "dojo/parser",
        "dojo/domReady!"
        ]);



require(["dojo/parser","dojo/domReady!"], function(parser){
    parser.parse();
    loadSystems();
});

function loadSystems()
{
    console.log("loadSystems");
    dojo.xhrGet({
        url: "http://10.21.2.17:9004/api_jpweb_wide_area",
        handleAs: "json",
        content : {
            "api_key" : "26a85c11cce867884dec4a7421e5bab9",
            "checksum" : "1",
            "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "get_fusion_wide_area_systems", "params" : {}, "id" : "1"}),
        },
        load: function(data){
            console.log(data);
            require(["dojo/query"], function(query){
                query("#systemsContainer").children().forEach(function(node){
                    dijit.byNode(node).destroyRecursive(true);
                    systemsContainer.innerHTML="";
                });
            });

          
            systems = data.result.fusion_wide_area_systems;
            console.log(systems);
            for (i in systems)
            {
                new System({name: systems[i].name, id: systems[i].id}).placeAt(dojo.byId("systemsContainer"));
                for (k in systems[i].fusion_wide_area_levels)
                {   
                    var isActive="notActive";
                    if (systems[i].fusion_wide_area_levels[k].active)
                        isActive="active";
                    new Level({levelName: systems[i].fusion_wide_area_levels[k].name, levelId: "level_id_" + systems[i].fusion_wide_area_levels[k].idx, active: isActive}).placeAt(dojo.byId("levelsContainer_"+systems[i].id));
                }
            }

        },
        error: function(error){
            console.log("An unexpected error occurred: " + error);
        }
    });
}



function createSystem()
{
    if (!createSystemForm.validate())
        return false;

    console.log("Create system");
    require(["dojo/dom-form"], function(domForm){
        var systemName = domForm.fieldToObject("systemName");


        dojo.xhrPost({
            url: "http://10.21.2.17:9004/api_jpweb_wide_area",
            handleAs: "json",
            content : {
                "api_key" : "26a85c11cce867884dec4a7421e5bab9",
                "checksum" : "1",
                "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "create_fusion_wide_area_system", "params" : {"name" : systemName}, "id" : "1"}),
            },
            load: function(data){
                console.log("system create succesfully");
                loadSystems();
                newSystemDialog.hide();  
                 return true; 
            },
            error: function(error){
                console.log("An unexpected error occurred: " + error);
                return false;
            }
        });

    });

   
}

function editSystem(systemId, sysName)
{
   if (!createSystemForm.validate())
        return false;

    console.log("editing system");
    require(["dojo/dom-form"], function(domForm){
        var systemName = domForm.fieldToObject("systemName");
        
         dojo.xhrPost({
            url: "http://10.21.2.17:9004/api_jpweb_wide_area",
            handleAs: "json",
            content : {
                "api_key" : "26a85c11cce867884dec4a7421e5bab9",
                "checksum" : "1",
                "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "update_fusion_wide_area_system", "params" : {"name" : systemName, "id": systemId}, "id" : "1"}),
            },
            load: function(data){
                console.log("system update succesfully");
                loadSystems();
                newSystemDialog.hide();   
            },
            error: function(error){
                console.log("An unexpected error occurred: " + error);
            }
        });
        
        //require(["dojo/dom-attr"], function( domAttr){
            //domAttr.set(dojo.byId("header_"+systemId), "innerHTML", systemName);                 
        //});


        //TODO change name
        //createSystemForm.reset();
        newSystemDialog.hide();   
    }); 
}

function openDialogForEditingSystem(systemId, sysName)
{
    dojo.attr(newSystemDialog.domNode, "data-system-id", systemId);
    dojo.attr(newSystemDialog, "title", "Edit system " + sysName);
    dojo.attr(systemName, "value", sysName);

    var handle = dojo.connect(dijit.byId("saveButtonSystem"), "onClick", function() {
        if(!editSystem(systemId, sysName))
            return false;
        createSystemForm.reset(); 
        dojo.disconnect(handle);
    });

    dojo.connect(dijit.byId("cancelButtonSystem"), "onClick", function() {
        createSystemForm.reset(); 
        newSystemDialog.hide();
        dojo.disconnect(handle);

    });

    newSystemDialog.show();
}

function openDialogForCreatingSystem()
{
    dojo.attr(newSystemDialog, "title", "Create system");

    var handle = dojo.connect(dijit.byId("saveButtonSystem"), "onClick", function() {
        if(!createSystem()) 
            return false;
        createSystemForm.reset(); 
        dojo.disconnect(handle);
    });

    dojo.connect(dijit.byId("cancelButtonSystem"), "onClick", function() {
        createSystemForm.reset(); 
        newSystemDialog.hide();
        dojo.disconnect(handle);

    });

    newSystemDialog.show();
}


function loadDataInSelects()
{
     dojo.xhrGet({
        url: "http://10.21.2.17:9004/api_jpweb_wide_area",
        handleAs: "json",
        content : {
            "api_key" : "26a85c11cce867884dec4a7421e5bab9",
            "checksum" : "1",
            "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "get_jp_models", "params" : {}, "id" : "1"}),
        },
        load: function(data){

            while(jp_model_select.options.length)
            {
                jp_model_select.removeOption(0);
            }

            var models = data.result.fusion_jp_models;
            var options = [];
            for (i in models) 
            {
                options.push({value : models[i].id,  label: models[i].jp_model, selected: false });
            }
            jp_model_select.addOption(options);
        },
        error: function(error){
            console.log("An unexpected error occurred: " + error);
        }
      });

    dojo.xhrGet({
        url: "http://10.21.2.17:9004/api_jpweb_wide_area",
        handleAs: "json",
        content : {
            "api_key" : "26a85c11cce867884dec4a7421e5bab9",
            "checksum" : "1",
            "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "get_currencies", "params" : {}, "id" : "1"}),
        },
        load: function(data){
                
            while(currency_select.options.length)
            {
                currency_select.removeOption(0);
            }


            var currencies = data.result.currencies;
            var options = [];
            for (i in currencies) 
            {
                options.push({value : currencies[i].id,  label: currencies[i].code, selected: false });
            }
            currency_select.addOption(options);
        },
        error: function(error){
            console.log("An unexpected error occurred: " + error);
        }
    });
}

function openDialogForCreatingLevel(systemId, systemName)
{
    dojo.attr(newLevelDialog.domNode, "data-system-id", systemId);
    dojo.attr(newLevelDialog, "title", "Create new level for " + systemName);

    loadDataInSelects();

    var handle = dojo.connect(dijit.byId("saveButtonLevel"), "onClick", function() {
        if(!createLevel(systemId))
            return false;
        createLevelForm.reset(); 
        dojo.disconnect(handle);
     });

    dojo.connect(dijit.byId("cancelButtonLevel"), "onClick", function() {
        createLevelForm.reset(); 
        newLevelDialog.hide();
        dojo.disconnect(handle);

    });

    newLevelDialog.show();
}

function oepnDialogForEditingLevel(levelId, levelName, systemId, systemName)
{
    //console.log(dojo.byId(levelId).parentNode.parentNode.id);
    dojo.attr(newLevelDialog.domNode, "data-system-id", systemId);
    dojo.attr(newLevelDialog.domNode, "data-level-id", levelId);
    dojo.attr(newLevelDialog, "title", "Edit level " + levelName);
    
    loadDataInSelects();
    //TODO load all fields

    var levelProperties;
    for (i in systems)
    {
        if(systems[i].id == systemId)
        {
            for(k in systems[i].fusion_wide_area_levels)
            {
                if(systems[i].fusion_wide_area_levels[k].idx == "level_id_" + levelId)
                {
                    levelProperties = systems[i].fusion_wide_area_levels[k];
                    break;
                }
            }
            break;
        }
    }
    console.log(levelProperties);

    var handle = dojo.connect(dijit.byId("saveButtonLevel"), "onClick", function() {
        if(!editLevel(systemId, sysName))
            return false;
        createLevelForm.reset();
        dojo.disconnect(handle);
     });

    dojo.connect(dijit.byId("cancelButtonLevel"), "onClick", function() {
        createLevelForm.reset(); 
        newLevelDialog.hide();
        dojo.disconnect(handle);

    });

    newLevelDialog.show();
}

function editLevel(systemId)
{
    console.log("eidt level");
    //if (!createLevelForm.validate())
    //    return false;

     require(["dojo/dom-form"], function(domForm){
        /*var levelName = domForm.fieldToObject("levelName");
        var isActive = domForm.fieldToObject("active");
        if(isActive==1)
            isActive = "active";
        else
            isActive = "notActive";

        var systemId = dojo.attr(newLevelDialog.domNode, 'data-system-id');
        new Level({levelName: levelName, levelId: levelName, active: isActive}).placeAt(dojo.byId("levelsContainer_"+systemId));
        var levelProperties = createLevelForm.getValues();
        levelProperties.system_id = "systemId";
        console.log(levelProperties);
        createLevelForm.reset();
        newLevelDialog.hide();         */    
    });

}


function createLevel(systemId)
{
    console.log("create level");
    if (!createLevelForm.validate())
        return false;

     //require(["dojo/dom-form"], function(domForm){
        //var levelName = domForm.fieldToObject("levelName");
        //var isActive = domForm.fieldToObject("active");
        //if(isActive==1)
        //    isActive = "active";
        //else
        //    isActive = "notActive";

        //var systemId = dojo.attr(newLevelDialog.domNode, 'data-system-id');
        //new Level({levelName: levelName, levelId: levelName, active: isActive}).placeAt(dojo.byId("levelsContainer_"+systemId));
        var levelProperties = createLevelForm.getValues();
        levelProperties.system_id = systemId;
        console.log(levelProperties);

         dojo.xhrPost({
            url: "http://10.21.2.17:9004/api_jpweb_wide_area",
            handleAs: "json",
            content : {
                "api_key" : "26a85c11cce867884dec4a7421e5bab9",
                "checksum" : "1",
                "payload_jsonrpc" : dojo.toJson({"jsonrpc": "2.0", "method": "create_fusion_wide_area_level", "params" : levelProperties, "id" : "1"}),
            },
            load: function(data){
                console.log("level create succesfully");
                console.log(data);
                loadSystems();
                //createLevelForm.reset();
                newLevelDialog.hide();  
                 return true; 
            },
            error: function(error){
                console.log("An unexpected error occurred: " + error);
                return false;
            }
        });
        
                     
    //});

}

