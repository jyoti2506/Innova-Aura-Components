({
    doInit : function(component, event, helper) {
        
        var flowAPIName = helper.getFlowNameParameter();
        component.set("v.flowAPIName", flowAPIName);
        
        const flow = component.find("screenFlow");
        flow.startFlow(flowAPIName);
        
    },
})