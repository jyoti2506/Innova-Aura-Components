({
    loadEmailMessage: function (component) {
        console.log('About to query SF for EmailMessage...');
        
        let emailMessageId = component.get("v.emailMessageId");
        
            let action = component.get("c.getEmailMessageById");
            action.setParams({
                "emailMessageId": emailMessageId
            });
            
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let emailMessage = response.getReturnValue();
                    console.log('Returned emailMessage ', emailMessage);
                    component.set("v.emailMessage", emailMessage);
                    
                    //resolve(emailMessage);
                } else {
                    let errors = response.getError();
                    if (errors) {
                        console.error('Unable to retrieve EmailMessage by Id.', errors);
                        //reject(errors);
                    }
                }
            });
            
            $A.enqueueAction(action);
        
    },
    
})