({
   
    executeAction : function(component, event, helper){
    	var navService = component.find("navService");
        
        var apiName = 'Service_Request__c'; 
        
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: apiName
            }
        };
        
        event.preventDefault();
        navService.navigate(pageReference);    
    }
})