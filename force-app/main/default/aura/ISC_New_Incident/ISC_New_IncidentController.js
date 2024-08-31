({
   init : function (component) {
      var flow = component.find("flowData");
      flow.startFlow("Case_Screen_Create_Incident");
   },

handleStatusChange : function (component, event) {
   if(event.getParam("status") === "FINISHED") {
      var outputVariables = event.getParam("outputVariables");
      var outputVar;
      for(var i = 0; i < outputVariables.length; i++) {
         outputVar = outputVariables[i];
         if(outputVar.name === "redirect") {

                var urlEvent = $A.get("e.force:navigateToSObject");
            	urlEvent.setParams({
               		"recordId": outputVar.value,
               		"isredirect": "true"
            	});
            	urlEvent.fire();

         }
      }
   }
},}
)