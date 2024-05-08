({ 
    //invoke : function(component, event, helper) {
//var caseId = component.get("v.recordId");
//var redirect = $A.get("e.force:navigateToSObject");
//redirect.setParams({
 //   "recordId":caseId
//});
//redirect.fire();
        
        invoke : function(component, event, helper) {
        var homeUrl = "/Service/s/"; 
     	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": homeUrl
        });
        urlEvent.fire();
}})