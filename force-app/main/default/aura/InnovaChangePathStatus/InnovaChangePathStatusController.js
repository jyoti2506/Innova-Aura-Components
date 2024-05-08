({
    doInit : function(component, event, helper) {
         var recIdValue = helper.getRecIdParameter();
        console.log('recIdValue: ' + recIdValue);
        component.set("v.recordId", recIdValue);
        var action = component.get("c.getChangeRequestStatusPath");
        action.setParams({
            "changeRequestId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.statusPath", response.getReturnValue());
            } else {
                console.log('Error fetching change request status path');
            }
        });
        $A.enqueueAction(action);
    }
})