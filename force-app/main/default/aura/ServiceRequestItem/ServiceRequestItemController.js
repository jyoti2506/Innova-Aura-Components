({
    
    init: function(component, event, helper) {
        
        let showCategories = component.get("v.showCategories");
        
        if( showCategories == "false") helper.handleNoCategory(component, event, helper);
    },
    
	handleCategorySelected : function(component, event, helper) {
		
        // Get the selected category name from the event
        const categoryName = event.getParam("categoryName");
        console.log("listened for category: " + categoryName)
        // Set the selected category name in the component attribute
        component.set("v.category", categoryName);
        
        var action = component.get("c.getRequestsByCategory");
        
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
        

    handleDivClick : function(component, event, helper){
        console.log('request clicked.');
    }
})