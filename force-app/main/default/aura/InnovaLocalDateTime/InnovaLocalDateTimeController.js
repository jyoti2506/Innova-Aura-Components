({
	init: function(component, event, helper) {
        
        console.log('UTC time received: ', component.get("v.utcTime"));
        helper.convertUTCtoLocal(component, event, helper);
        
    },
})