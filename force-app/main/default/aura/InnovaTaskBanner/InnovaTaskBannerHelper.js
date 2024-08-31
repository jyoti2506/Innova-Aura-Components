({
    getRecIdParameter : function() {
        
        var params = window.location.search.substring(1);
        //console.log('params: ', params);
        
        var vars = params.split("&");
        
        for (var i=0; i<vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] === "recId") {
                return decodeURIComponent(pair[1]);
            }
        }
        return null; // If recId parameter is not found
    },
    
    getTaskRecord : function(component) {
        
        var recordId = component.get("v.recordId");
    	var action = component.get("c.getTask");
        
        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('result: ', result);
                component.set("v.task", result);
            } else {
                var errors = response.getError();
                if (errors) {
                    console.log('error in getTask!', errors);
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getBannerData :function(component, event, helper){
        
        var action = component.get("c.getTaskBannerData");
        
        action.setParams({
            recordId: component.get("v.recordId")
        })
        action.setCallback(this, function(response) { 
            var returnValue = JSON.parse(response.getReturnValue());
            component.set("v.conDetails", returnValue);
            console.log('conDetails: ', returnValue);
        })
        $A.enqueueAction(action);
    },
        

})