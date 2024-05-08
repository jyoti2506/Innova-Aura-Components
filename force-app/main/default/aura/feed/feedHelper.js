({
	getNewsFeed: function(component) {
        var feedContainer = component.find("feedContainer");
        $A.createComponent("forceChatter:feed", {"type": "News", "subjectId": ""}, function(feed) {
            feedContainer.set("v.body", [feed]);
        });
    }
})