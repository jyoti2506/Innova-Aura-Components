({
    getCurrentUser: function (component) {
        var action = component.get("c.getCurrentUserDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.currentUser", response.getReturnValue());
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    stripHtmlTags: function (html) {
        var doc = new DOMParser().parseFromString(html, 'text/html');
        return doc.body.textContent || "";
    },
    
    loadCommentsFromServer: function (component, recordId) {
        
        var action = component.get("c.getCaseCommentswithEmail");
        
        action.setParams({
            "caseRecordId": recordId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('email comment result: ', result);
                component.set("v.CommentsWithFormattedTime", result);
                //component.set("v.feedCommentWrapperTime", result.FeedComments);
            } else {
                var errors = response.getError();
                if (errors) {
                    console.log('error in loadCommentsFromServer');
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    loadComments: function (component, recordId) {
        var action = component.get("c.getCaseComments");
        action.setParams({
            "caseRecordId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                // Iterate through comments and strip HTML tags
                for (var i = 0; i < result.length; i++) {
                    result[i].CommentBody = this.stripHtmlTags(result[i].CommentBody);
                    console.log('result: ', JSON.stringify(result));
                    //alert(JSON.stringify(result));
                }
                
                component.set("v.feedCommentWrapperTime", result);
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
     
    loadCommentsFromStorage: function (component) {
        var storedComments = localStorage.getItem('capturedComments');
        if (storedComments) {
            component.set("v.allComments", JSON.parse(storedComments));
        }
    },
    storeCommentsInStorage: function (comments) {
        localStorage.setItem('capturedComments', JSON.stringify(comments));
    },
    checkCaseStatus: function (component, recordId, callback) {
        var action = component.get("c.getCaseStatus");
        action.setParams({
            "caseRecordId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var caseStatus = response.getReturnValue();
                callback(caseStatus);
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    createFeedComment: function (component, feedIdValue, postContent,helper) {
        var recordId = component.get("v.recordId");
        var div = document.createElement("div");
        div.innerHTML = postContent;
        var plainTextContent = div.textContent || div.innerText || "";
        
        var action = component.get("c.createFeedCommentMethod");
        
        if (action) {
            action.setParams({
                "feedItemId": feedIdValue,
                "postContent": plainTextContent
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    
                    if (toastEvent) {
                        toastEvent.setParams({
                            "title": "Success",
                            "message": "Chatter post created successfully",
                            "type": "success"
                        });
                        toastEvent.fire();
                    }
                    
                    // Append the comment with user information to the existing comments
                    var allComments = component.get("v.allComments");
                    allComments.push({
                        content: plainTextContent,
                        timestamp: new Date().toLocaleString()
                    });
                    component.set("v.allComments", allComments);
                    
                    // Store comments in localStorage
                    this.storeCommentsInStorage(allComments);
                    
                    // Clear the rich text box
                    component.set("v.myComment", "");
                } else {
                    var errors = response.getError();
                    
                    if (errors) {
                        var errorMessage = "Error creating Chatter post: ";
                        
                        for (var i = 0; i < errors.length; i++) {
                            errorMessage += errors[i].message;
                        }
                        
                        var toastEvent = $A.get("e.force:showToast");
                        
                        if (toastEvent) {
                            toastEvent.setParams({
                                "title": "Error",
                                "message": errorMessage,
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }
                }
            });
             $A.get('e.force:refreshView').fire();
            $A.enqueueAction(action);
            this.loadCommentsFromServer(component, recordId);
        } else {
            console.error("Action is not initialized");
        }
    }
    
})