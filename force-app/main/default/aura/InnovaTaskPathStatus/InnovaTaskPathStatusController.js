({
	doInit : function(component, event, helper) {
         var recIdValue = helper.getRecIdParameter();
        console.log('recIdValue: ' + recIdValue);
        component.set("v.recordId", recIdValue);
        var action = component.get("c.getTaskStatusPath");
        action.setParams({
            "taskId": recIdValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('path query success.');
                component.set("v.statusPath", response.getReturnValue());
            } else {
                console.log('Error fetching task status path');
            }
        });
        $A.enqueueAction(action);
    }
})