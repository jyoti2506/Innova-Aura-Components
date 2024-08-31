({
    //always use the Lightning Navigation Service.
    //The navigation appears smoother to the user
    //There is no need to construct complicated urls
    //Salesforce handles url security.
    
    navigateToPage : function(component, event, helper){
        
        let flowAPIName = component.get("v.flowAPIName");
        
        let navService = component.find("navService");
        
        let pageAPIName = 'Service_Request_Form__c';

        let pageReference = {
            
            type: "comm__namedPage",
            attributes: {
                name: pageAPIName
            },
            state: {
                flowName: flowAPIName,
            }
        };
        
        event.preventDefault();

        navService.navigate(pageReference);
    },
})