({
    
    convertUTCtoLocal : function (component, event, helper){
        
        console.log('About to convert UTC to Local Timezone...');
      
        let utc = component.get("v.utcTime");
        
        let action = component.get("c.getFormattedTimeDifference");
        
        action.setParams({
            "commentDateTime": utc
        });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                
                let localTime = response.getReturnValue();
                component.set("v.localTime", localTime);
                
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
})