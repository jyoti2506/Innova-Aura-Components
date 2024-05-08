({
    doInit : function(component, event, helper) { 
        var recIdValue = helper.getRecIdParameter();
        component.set("v.recordId", recIdValue);
        console.log('Record ID: ', recIdValue);

        // Fetch the title
        var actionTitle = component.get("c.getArticleTitleById");
        actionTitle.setParams({ "kbId": recIdValue });
        actionTitle.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Article Title: ', response.getReturnValue());
                component.set("v.articleTitle", response.getReturnValue());
            } else {
                console.error("Failed to fetch article title: ", state);
            }
        });
        $A.enqueueAction(actionTitle);

        // Fetch the body
        var actionBody = component.get("c.getKnowledgeBodyById");
        actionBody.setParams({ "kbId": recIdValue });
        actionBody.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Article Body: ', response.getReturnValue());
                component.set("v.articleBody", response.getReturnValue());
            } else {
                console.error("Failed to fetch article body: ", state);
            }
        });
        $A.enqueueAction(actionBody);
    },

    setSelectedArticle: function(component, event, helper) {
        var selectedTitle = "Selected Article Title"; // This should be dynamically assigned
        component.set("v.selectedArticle", selectedTitle);
    }
})