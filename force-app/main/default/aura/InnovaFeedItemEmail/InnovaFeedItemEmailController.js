({
	 init: function(component, event, helper) {
        console.log('EmailMessageId received ', component.get("v.emailMessageId"));
        helper.loadEmailMessage(component);
        
    },
    
})