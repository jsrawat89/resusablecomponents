({
	getDetails: function(component, event, helper) {    
        var oppId = component.get("v.recordId");
        console.log("Oppid==>"+oppId);
        var action = component.get("c.getOpportunityRecordwinloss");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
				component.set("v.OppWrapper",response.getReturnValue());
                console.log(component.get("v.OppWrapper"));
               
              //  if(response.getReturnValue().oppObj.StageName == 'Closed Lost'){
                    var lossreasonopt = JSON.parse(response.getReturnValue().lossreasonOpts);                
                    component.find("lostreason").set("v.options",lossreasonopt);
                    
                    var complossopt = JSON.parse(response.getReturnValue().complosstoOpts);                
               		component.find("comploss").set("v.options",complossopt);
              // }
                
                //if(response.getReturnValue().oppObj.StageName == 'Closed Won'){                
                    var winreasonopt = JSON.parse(response.getReturnValue().winreasonOpts);  
                    component.find("winreason").set("v.options",winreasonopt);
                //}
                
                var stagenameopt = JSON.parse(response.getReturnValue().stagenameOpts);  
                component.find("stagename").set("v.options",stagenameopt);
                
                
                
                component.set("v.hideviewsection","slds-show");
        		component.set("v.hideeditsection","slds-hide");
               
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