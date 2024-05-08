({
	 handleResolvedButtonClick : function(component, event, helper) {
        // Set the recordId and open the modal
        component.set("v.isModalOpen", true);
        // You may also set the recordId based on your requirements
        // component.set("v.caseRecordId", "yourCaseId");
    }
})