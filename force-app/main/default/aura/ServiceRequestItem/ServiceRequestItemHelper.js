({
	getRequestsByCategory : function(component, event, helper){
        
        var action = component.get("c.getRequestsByCategory");
        let categoryName = component.get("v.categoryName");
        
        action.setParams({
            "categoryName": categoryName
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let requests = response.getReturnValue();
                console.log("returned requests: ", requests);
                component.set("v.availableRequests", requests);
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleNoCategory : function(component, event, helper){
        helper.getRequestsByCategory(component, event, helper);
    }
})