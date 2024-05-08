({ 
    init: function(component, event, helper) {
        var activeSections = [];
        component.set("v.activeSections", activeSections);
        helper.getCurrentUser(component);
        helper.loadCommentsFromStorage(component);
        helper.loadCommentsFromServer(component, component.get("v.recordId"));
        helper.loadComments(component, component.get("v.recordId"));
        
    },
     
    
    loadRelatedRecordSubject: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getRelatedRecordSubject");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.relatedRecordSubject", response.getReturnValue());
            } else {
                var errors = response.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sendPost: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var postContent = component.get("v.myVal");
        
        if (!postContent || !postContent.trim()) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Warning",
            "message": "Please add a comment before clicking the post button.",
            "type": "warning"
        });
        toastEvent.fire();
        return;
    }
        
        // Check if the case is closed before allowing the post
        var actionCheckStatus = component.get("c.checkCaseStatus");
        actionCheckStatus.setParams({
            "recordId": recordId
        });
        
        
        actionCheckStatus.setCallback(this, function (responseStatus) {
            var stateStatus = responseStatus.getState();
            if (stateStatus === "SUCCESS") {
                var isCaseClosed = responseStatus.getReturnValue();
                if (isCaseClosed=='Closed') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message":"Comments cannot be added to closed cases. If you require further assistance, please open a new case",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else {
                    // Continue with creating the post
                    var div = document.createElement("div");
                    div.innerHTML = postContent;
                    var plainTextContent = div.textContent || div.innerText || "";
                    var action = component.get("c.createChatterPost");
                    action.setParams({
                        "recordId": recordId,
                        "postContent": plainTextContent
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success",
                                "message": "Chatter post created successfully",
                                "type": "success"
                            });
                            toastEvent.fire();
                            
                            // Append the comment with user information to the existing comments
                            var allComments = component.get("v.allComments");
                            allComments.push({
                                content: plainTextContent,
                                timestamp: new Date().toLocaleString()
                            });
                            component.set("v.allComments", allComments);
                            
                            // Store comments in localStorage
                            helper.storeCommentsInStorage(allComments);
                            
                            // Clear the rich text box
                            component.set("v.myVal", "");
                        } else {
                            var errors = response.getError();
                            if (errors) {
                                var errorMessage = "Error creating Chatter post: ";
                                for (var i = 0; i < errors.length; i++) {
                                    errorMessage += errors[i].message;
                                }
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error",
                                    "message": errorMessage,
                                    "type": "error"
                                });
                                toastEvent.fire();
                            }
                        }
                    });
                    $A.enqueueAction(action);
                    helper.loadCommentsFromServer(component, component.get("v.recordId"));
                }
            } else {
                var errors = responseStatus.getError();
                if (errors) {
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(actionCheckStatus);
        
        helper.loadCommentsFromServer(component, component.get("v.recordId"));
    },
    setCurrentCommentId: function(component, event, helper) {
        var commentId = event.getParam("commentId");
        component.set("v.currentCommentId", commentId);
    },
    
    createComment: function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var postContent = component.get("v.myComment");
        var feedIdValue;
        var commentsWithFormattedTime = component.get("v.CommentsWithFormattedTime");
        
        for (var i = 0; i < commentsWithFormattedTime.length; i++) {
            if (i == index) { // Use == instead of === for type coercion
                if (commentsWithFormattedTime[i].ObjectType === 'FeedItem') {
                    feedIdValue = commentsWithFormattedTime[i].Id;
                    break;
                } else if (commentsWithFormattedTime[i].ObjectType === 'EmailMessage') {
                    feedIdValue = commentsWithFormattedTime[i].Id;
                    break;
                }
            }
        }
        
        helper.createFeedComment(component, feedIdValue, postContent);
    },
    
    sendcomment: function(component, event, helper) {
        // alert('method called');
        var index = event.getSource().get("v.name");
        component.set("v.showCommentBox", index);
        component.set("v.ShowCommentButton", false);
        //alert("Parent Comment Id: " + index);
        
    },
    
  
    handleSectionToggle: function(component, event, helper) {
        
        //var openSections = event.getParam('section').name;
        var openSections = event.getParam('openSections');
        console.log('openSections: ', openSections);
        
        var activeSections = component.get("v.activeSections");
        console.log('activeSections: ', activeSections);
        
        /*
        var index = activeSections.indexOf(openSections);
        console.log('index: ', index);
        
       
        if (index > -1) {
            activeSections.splice(index, 1);
        } else {
            
            activeSections.push(openSections);
        }
        component.set("v.activeSections", activeSections);
        */
    },
    
})