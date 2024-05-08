({
	getFlowNameParameter : function() {
        
        var params = window.location.search.substring(1);
        //console.log('params: ', params);
        
        var vars = params.split("&");
        
        for (var i=0; i<vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] === "flowName") {
                return decodeURIComponent(pair[1]);
            }
        }
        return null; // If flowName parameter is not found
    },
})