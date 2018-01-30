({
	createRecord : function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var recordtypeID = component.get("v.recordtypeId");
       
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Event",
            "recordTypeId" : recordtypeID,
             "defaultFieldValues": {
                'WhatId' : recordId                 
            }
                 
        });
        createRecordEvent.fire();
    },
    doInit: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var recordtypeID  = component.get("v.recordtypeId");
        
        console.log('recordId ==>'+recordtypeID);
        var action = component.get("c.getEventlist");
        action.setParams({
            "recordId": recordId,
            "recordTypeId" : recordtypeID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
				component.set("v.eventlist",response.getReturnValue());
                console.log(response.getReturnValue());
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
    },
    showdetail: function (component, event, helper) {
        var eventId = event.target.getAttribute('data-id');

        console.log(eventId);
         var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": eventId,
          "slideDevName": "detail"
        });
        navEvt.fire();
	},
    editRecord : function(component, event, helper) {
        var eventId = event.target.getAttribute('data-id');
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": eventId
       });
        editRecordEvent.fire();
    }
})