({
	showToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error!",
        "message": "You cannot comment when status is closed.", 
        "variant": "error" 
    });
    toastEvent.fire();
}
})