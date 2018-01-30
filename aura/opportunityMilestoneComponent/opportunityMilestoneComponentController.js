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
    saveRecord: function(component, event, helper) {  
         var action = component.get("c.saveOpportunity");
         var oppObj = component.get("v.OppObj");
        
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
    }})