({
     openModel: function(component,event,helper) {
        
        // Set isModalOpen attribute to true
        
        component.set("v.isModalOpen", true);
        
        // Find the component whose aura:id is "flowData"
        
        var flow = component.find("flowData");
        
        // In that component, start your flow. Reference the flow's API Name.        
        
        flow.startFlow("Innova_Created_My_Support_Ticket_Form_From_Portal_Side");
        
    },
    
    closeFlowModal : function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
        
        // window.location.reload();
        
    },
    
    closeModel: function(component,event,helper) {
        
        // Set isModalOpen attribute to false  
        
        if(event.getParam('status') === "FINISHED") {
            
            component.set("v.isModalOpen", false);
            
        }
        
    }
    
})