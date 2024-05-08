({
	//getNewsFeed: function(component) {
       // var feedContainer = component.find("feedContainer");
       // $A.createComponent("forceChatter:feed", {"type": "News", "subjectId": ""}, function(feed) {
           // feedContainer.set("v.body", [feed]);
        //});
    //}
    //
    getCommentsAndEmails: function(component) {
        var action = component.get("c.getCommentsAndEmails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.feedItems", response.getReturnValue());
            } else {
                console.error("Failed to fetch comments and emails");
            }
        });
        $A.enqueueAction(action);
    }
})