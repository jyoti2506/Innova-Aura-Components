({
  doInit : function(component, event, helper) {
        var action = component.get("c.getSelectedKnowledgeTitle");
        
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.title", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }
})