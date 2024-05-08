({
	 doInit : function(component, event, helper) {
        var Caseid = component.get("v.recordId");
        var caseId = component.get("{!v.CaseObject.Id}");
        var action = component.get('c.getCases');
        
        action.setParams({"cId":Caseid});
        
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if(state == 'SUCCESS'){
                var records = response.getReturnValue();
                
                if(records){
                    component.set('v.isOpen', true);
                    var flow = component.find('flow');
                   flow.startFlow('Innova_Popup_for_Case_Details1');
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    closeFlowModal : function(component, event, helper) {
         component.set("v.isOpen", false);

    },
    
    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam("status") === "FINISHED") {
            var caseId = component.get("{!v.CaseObject.Id}");
            component.set("v.isOpen", false);
           window.location.reload();
        }
    }
     

})