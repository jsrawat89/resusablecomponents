({
	getDetails: function(component, event, helper) {    
        var oppId = component.get("v.recordId");
        console.log("Oppid==>"+oppId);
        var action = component.get("c.getOpportunityRecordmilestones");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
				component.set("v.OppObj",response.getReturnValue());
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