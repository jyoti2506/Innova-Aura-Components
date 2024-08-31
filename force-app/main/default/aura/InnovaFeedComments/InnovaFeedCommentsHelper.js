({
    loadFeedComments: function (component) {
        console.log('About to check query SF for Case status...');
        
        let feedItemId = component.get("v.feedItemId");
        
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get("c.getFeedCommentsByFeedItemId");
            action.setParams({
                "feedItemId": feedItemId
            });
            
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let comments = response.getReturnValue();
                    console.log('Returned comments ', comments);
                    component.set("v.feedComments", comments);
                    resolve(comments);
                } else {
                    let errors = response.getError();
                    if (errors) {
                        console.error('Unable to retrieve comments from FeedItem.', errors);
                        reject(errors);
                    }
                }
            });
            
            $A.enqueueAction(action);
        }));
    },
})