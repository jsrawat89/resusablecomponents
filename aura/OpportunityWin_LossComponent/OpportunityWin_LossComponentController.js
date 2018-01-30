({
	doInit: function(component, event, helper) {    
        helper.getDetails(component, event, helper);
    },
    showEdit: function(component, event, helper) {  
        component.set("v.hideviewsection","slds-hide");
        component.set("v.hideeditsection","slds-show");
    },
    cancelEdit: function(component, event, helper) {  
        helper.getDetails(component, event, helper);        
    },
    stageChange: function(component, event, helper) {  
        var OppWrapper = component.get("v.OppWrapper");
        var winreason = component.find("winreason");
        if(winreason != undefined)
        	component.find("winreason").set("v.value","");
        var lostreason = component.find("lostreason");
        if(lostreason != undefined)
        	component.find("lostreason").set("v.value","");
        var comploss = component.find("comploss");
        if(comploss != undefined)
        	component.find("comploss").set("v.value","");
        
       /* if(OppWrapper.oppObj.StageName == 'Closed Lost'){
            var lossreasonopt = JSON.parse(OppWrapper.lossreasonOpts);                
            component.find("lostreason").set("v.options",lossreasonopt);
            
            var complossopt = JSON.parse(OppWrapper.complosstoOpts);                
            component.find("comploss").set("v.options",complossopt);
            
           
        }
        
        if(OppWrapper.oppObj.StageName == 'Closed Won'){                
          //  var winreasonopt = JSON.parse(OppWrapper.winreasonOpts);  
           // component.find("winreason").set("v.options",winreasonopt);
          
        }*/
    },
    saveRecord: function(component, event, helper) {  
         var action = component.get("c.saveOpportunity");
         var oppObj = component.get("v.OppWrapper.oppObj");
        
         action.setParams({
             oppObjJson : JSON.stringify(oppObj)
         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                helper.getDetails(component, event, helper);
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on profile load: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error profile view");
                }
            }
        });
        $A.enqueueAction(action);     
    }
})