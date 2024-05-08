// EmailMessagesHelper.js
({
    loadEmailMessages: function (component, caseId) {
        var action = component.get("c.getEmailMessages");
        action.setParams({
            "caseId": caseId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var emailMessages = response.getReturnValue();
                component.set("v.emailMessages", emailMessages);
            } else {
                // Handle errors
            }
        });

        $A.enqueueAction(action);
    }
})