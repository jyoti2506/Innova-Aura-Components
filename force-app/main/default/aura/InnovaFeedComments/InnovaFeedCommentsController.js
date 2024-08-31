({
	 init: function(component, event, helper) {
        console.log('InnovaFeedComments received ', component.get("v.feedItemId"));
        helper.loadFeedComments(component);
        
    },
})