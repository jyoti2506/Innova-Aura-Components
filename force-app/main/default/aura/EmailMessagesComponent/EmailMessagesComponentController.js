({
    init: function (component, event, helper) {
        // Get the Case Id from the parent component
        var caseId = component.get("v.recordId");
        component.set("v.caseId", caseId);

        // Load email messages
        helper.loadEmailMessages(component, caseId);
    },
    
   
})