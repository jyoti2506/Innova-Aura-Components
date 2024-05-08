({
    
    init : function(component, event, helper){
        
        console.log('recordId: ', component.get("v.recordId"));
        
        if(!component.get("v.recordId")){
            //get recordId from url
            var params = window.location.search.substring(1);
            var localRecordId;
            //console.log('params: ', params);
            
            var vars = params.split("&");
            
            for (var i=0; i<vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] === "recId") {
                    localRecordId = decodeURIComponent(pair[1]);
                    component.set("v.localRecordId", decodeURIComponent(pair[1]) );
                }
            }
        } else {
            localRecordId = component.get("v.recordId");
        }
        //get workItemId to approve
        var action = component.get('c.getWorkItemId');
        action.setParams({ 
            recordId: localRecordId 
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('retrieve workItemId: ', response.getReturnValue());
                
                component.set("v.workItemId", response.getReturnValue());
            } else if (state === "ERROR") {
                console.error('workItemId error: ', response.getError());
                // Show error message
            }
        });
        $A.enqueueAction(action);
  

    },
    
	openModal : function(component, event, helper) {
		const clickedButtonLabel = event.getSource().get("v.label");
        
        component.set("v.modalTitle", clickedButtonLabel);
        component.set("v.isModalOpen", true);
	},
    
    closeModal : function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    processDecision : function(component, event, helper){
                
        var action = component.get('c.processRecords');
        
        action.setParams({
            lstWorkItemIds : component.get("v.workItemId"),
            processType : component.get("v.modalTitle"),
            commentFromUser : component.get("v.comment")
            
        });
        action.setCallback(this,function(response){
            $A.get('e.force:refreshView').fire();
            var state = response.getState();
            var toastRef = $A.get('e.force:showToast');
            if(state == 'SUCCESS'){
                var message = response.getReturnValue();
                if(message.includes('success')){
                    toastRef.setParams({
                        'type' : 'success',
                        'title' : 'Success',
                        'message' : message,
                        'mode' : 'dismissible'
                    });
                }
                else{
                    toastRef.setParams({
                        'type' : 'error',
                        'title' : 'Error',
                        'message' : message,
                        'mode' : 'sticky'
                    });
                }
                toastRef.fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
        
    },
    
})