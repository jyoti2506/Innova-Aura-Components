({
   getFieldSet :function(component,event,helper){
        var action = component.get("c.getJSONFieldSet");
        action.setParams({
            "sObjectName":"Case",
            "sFieldSetName":"Case_Banner"
        })
        action.setCallback(this, function(response) {            
            if(response.getState()=="SUCCESS"){
                var fieldSetObj = JSON.parse(response.getReturnValue());
                console.log(fieldSetObj);                
                component.set("v.fieldSetValues", fieldSetObj);
                console.log('get fieldset=>'+JSON.stringify(fieldSetObj));
                this.getData(component,event,helper);
            }
            else{
                console.log(response.getError());
            }
        })
        
        $A.enqueueAction(action);
    },
    
    getData :function(component,event,helper){
        var h = component.get("v.fieldSetValues");
        const field=[];
        const fList=[];
        console.log(h);
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
            component.set("v.conDetails", response.getReturnValue());
            console.log("FinalconDetail--->"+JSON.stringify(response.getReturnValue()));
        })
        $A.enqueueAction(action);
    }
})