({
	getActiveCategories: function (component) {
        var action = component.get("c.getActiveCategories");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let activeCategories = response.getReturnValue();
                console.log("active categories: ", activeCategories);
                component.set("v.catalogCategories", activeCategories);
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sendCategoryClickEvent: function(component, event, helper){
        
        const clickedDiv = event.currentTarget;
        const category = clickedDiv.getAttribute('data-category');
        
        console.log("Category clicked:", category);
        
        var categoryEvent = $A.get("e.c:ServiceRequestCategoryClicked");
        categoryEvent.setParams({
            "categoryName": category
        });
        categoryEvent.fire();
    }
})