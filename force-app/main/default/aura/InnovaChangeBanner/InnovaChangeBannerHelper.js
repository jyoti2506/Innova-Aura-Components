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
    
    getChangeRecord : function(component) {
        
        var recordId = component.get("v.recordId");
    	var action = component.get("c.getChangeRequest");
        
        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('result: ', result);
                component.set("v.changeRecord", result);
            } else {
                var errors = response.getError();
                if (errors) {
                    console.log('error in getChangeRecord!', errors);
                    // Handle errors
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getBannerData :function(component, event, helper){
        
        var action = component.get("c.getChangeRequestBannerData");
        
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
        
   /* getData :function(component,event,helper){
        
        var h = JSON.parse('[{"label":"Case Number","value":"C-00031175"},{"label":"Service","value":"Finance Services"},{"label":"Category","value":"Commissions"},{"label":"Subcategory","value":"Other Costs"},{"label":"Created Date","value":"03/27/2024 00:26 AM"}]');
        
        const field=[];
        const fList=[];
        console.log('data: ', h);
        for(var x of h){
            field.push(x.name);
            fList.push(x.label);
        }
        console.log(field);
        console.log(fList)
        
        var action = component.get("c.getCase");
        action.setParams({
            id: component.get("v.recordId"),
            fieldList: field,
            fieldLabel: fList
        })
        action.setCallback(this, function(response) { 
            //component.set("v.conDetails", response.getReturnValue());
            component.set("v.conDetails", h);
            console.log("FinalconDetail--->"+JSON.stringify(response.getReturnValue()));
        })
        $A.enqueueAction(action);
    }, */
})