({
    //Method call on load of Lightning Component
    doInit : function(component,event,helper){
        helper.doInitHelper(component,event,helper);
    },
    
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    openModal2: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen2", true);
    },
    closeModal2: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen2", false);
    },
    
    handleRowAction : function(component, event, helper){
      	helper.handleRowAction(component,event,helper);
    },
    
    //Method to handle sorting of records
    handleSortingOfRows : function(component,event,helper){
        helper.handleSortingOfRows(component,event);
    },
    
    //Method to enable or disable Approve and Reject button
    handleRowSelection : function(component,event,helper){
        console.log('handleRowSelection');
        helper.handleRowSelection(component,event,helper);
    },
    
    //Method to Approve the selected records
    handleApproveAction : function(component,event,helper){
        helper.processSelectedRecords(component,event,helper,'Approve');
        component.set("v.isModalOpen", false);
    },
    
    //Method to Reject the selected records
    handleRejectAction : function(component,event,helper){
        helper.processSelectedRecords(component,event,helper,'Reject');
        component.set("v.isModalOpen2", false);
    }
})