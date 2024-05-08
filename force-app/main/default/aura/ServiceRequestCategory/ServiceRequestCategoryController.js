({
	init: function(component, event, helper) {
		helper.getActiveCategories(component);
	},
    
    handleDivClick: function(component, event, helper){     
        helper.sendCategoryClickEvent(component, event, helper);
    }
})