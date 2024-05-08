({
    doInit : function(component, event, helper) {
        helper.init(component, event, helper);
    },
    
	actionButtonClick: function(component, event, helper) {
        helper.openModal(component, event, helper);
    },
    
    closeButtonClick: function(component, event, helper) {
        helper.closeModal(component, event, helper);
    },
    
    
    submitButtonClick : function(component, event, helper){
        helper.processDecision(component, event, helper);
    },
})