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
    
	getDetailData : function(component, event, helper){
        
        console.log('getDetailData');
        var action = component.get("c.getChangeRequestDetail");
        
        action.setParams({
            recordId: component.get("v.recordId")
        })
        action.setCallback(this, function(response) { 
            //console.log(response.getReturnValue());
            var returnValue = JSON.parse(response.getReturnValue());
            component.set("v.conDetails", returnValue);
            console.log('conDetails: ', returnValue);
        })
        $A.enqueueAction(action);
    },
})