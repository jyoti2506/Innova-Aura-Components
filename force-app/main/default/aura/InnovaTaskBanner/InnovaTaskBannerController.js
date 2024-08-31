({
	 doInit : function(component, event, helper) {
        
    var recIdValue = helper.getRecIdParameter();
        component.set("v.recordId", recIdValue);
  
        helper.getBannerData(component, event, helper);
        helper.getTaskRecord(component, event, helper);
    }
})