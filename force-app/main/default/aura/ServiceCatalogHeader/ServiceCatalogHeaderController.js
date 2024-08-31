({
    doInit : function(component, event, helper) {
        // Get flowApiName from the URL
        var flowApiName = helper.getURLParameter('flowName');
        component.set("v.flowApiName", flowApiName);
        
        // Call Apex method to get the title
        var action = component.get("c.getTitleByFlowApiName");
        action.setParams({ flowApiName : flowApiName });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.title", response.getReturnValue());
            }
            else {
                console.error("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    }
})