({
    openModal: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },

    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    handleConfirm: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        // Code to execute if the user clicks 'Confirm' 
        helper.executeAction(component, event);
    }
})