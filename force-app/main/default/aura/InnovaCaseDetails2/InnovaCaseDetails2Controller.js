({
    doInit: function(component, event, helper) {   
        //  debugger;
        console.log('The other component is doInit!')
        var id = component.get("v.recordId");
        console.log(id);
        
        var action = component.get('c.getCaseRecord');
        action.setParams({"objectId":component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var recordType = response.getReturnValue();
                if(recordType == $A.get('$Label.c.IncidentRecordIDs')) {
                    var fieldSetName = 'Innova_Case_Details';
                    component.set("v.fieldSetTitle", 'My Ticket Details');
                    helper.getFieldSet(component, event, helper, fieldSetName);
                }
                else {
                    var fieldSetName = 'Innova_Case_Details';
                    component.set("v.fieldSetTitle", 'Service Request Details');
                    helper.getFieldSet(component, event, helper, fieldSetName);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
})