({
    invoke : function(component, event, helper) {
        var navigateHomeEvent = $A.get("e.force:navigateHome");
        navigateHomeEvent.fire();
    }
})