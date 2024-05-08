({
    doInit : function(component,event,helper){
        
        component.set("v.isModalOpen", true);
        
        var flow = component.find("flowData");
        
        
        // In that component, start your flow. Reference the flow's API Name.        
        
        flow.startFlow("Innova_Created_My_Support_Ticket_Form_From_Portal_Side");
    },
    
    closeFlowModal : function(component, event, helper) {
        var homeUrl = "https://innovasolutionsitsc.my.site.com/ITSC/s/"; 
     var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": homeUrl
        });
        urlEvent.fire();
    },
     // component.set("v.isModalOpen", false);
        
     // window.location.reload();
        

    
    closeModel: function(component,event,helper) {
        
        // Set isModalOpen attribute to false  
        
        if(event.getParam('status') === "FINISHED") {
            
            component.set("v.isModalOpen", false);
            
        }
        
    }
})