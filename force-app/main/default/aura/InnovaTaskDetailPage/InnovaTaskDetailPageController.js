({
	doInit : function(component, event, helper) {
		console.log('doInit detail page');
        var recIdValue = helper.getRecIdParameter();
        component.set("v.recordId", recIdValue);
  
        helper.getDetailData(component, event, helper);
        
	}
})