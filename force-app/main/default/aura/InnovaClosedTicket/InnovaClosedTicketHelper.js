({
        fetchData: function(component){
            
            
            
            this.fetchCases(component)
        	.then(() => this.fetchCasePages(component))
        	.then(() => this.fetchTZ(component))
        	.then(() => this.setButtonVisibility(component))
            .then(() => this.removeSpinner(component))
        .catch(error => console.error('Error in Promise Chain:', error)); 
            
    },
    
    removeSpinner: function(component){
        this.setAttribute(component, "isLoading", false);
    },
    
    //after each button click, call this function to update paging buttons visibility in the DOM
    setButtonVisibility: function(component){
        
        
        const pageNumber = this.getAttribute(component, "pageNumber");
        const totalPages = this.getAttribute(component, "pageTotal");
        
        console.log('--start setButtonVisibility');
        
        const msg = 'pageNumber ' + pageNumber + ' of totalPages: ' + totalPages;  
        console.log(msg)
        
        // Disable 'First' and 'Previous' if we're at the first page
        this.setAttribute(component, "disableFirstButton", pageNumber <= 1);
        this.setAttribute(component, "disablePreviousButton", pageNumber <= 1);
        
        // Disable 'Next' and 'Last' if we're at the last page
        this.setAttribute(component, "disableNextButton", pageNumber >= totalPages);
        this.setAttribute(component, "disableLastButton", pageNumber >= totalPages);
        
		console.log('--end setButtonVisibility');
    },
    
    fetchCases: function(component) {
        
        return new Promise((resolve, reject) => {
            
            let pageNumber = this.getAttribute(component, "pageNumber");
            let pageSize = this.getAttribute(component, "pageSize");
            let searchKeyword = this.getAttribute(component, "searchKeyword"); // Added line to get search keyword
            
            let action = component.get("c.getCases");
            action.setParams({
                "pageNumber": pageNumber,
                "pageSize": pageSize,
                "searchKeyword": searchKeyword // Added parameter for search
            });
        
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('fetchCases Promise Resolved.');
                    component.set("v.cases", response.getReturnValue());
                    resolve();
                } else {
                    console.error('Error fetching cases');
                    reject('Error fetching cases');
                }
            });
            $A.enqueueAction(action);

        });
        
        
        
    },
    
      fetchCasePages: function(component){
       
        return new Promise((resolve, reject) => {
            
            var action=component.get("c.getCasesTotal");
            var searchKeyword = component.get("v.searchKeyword");
            var pageSize = component.get("v.pageSize");
            
            action.setParams({
            "searchKeyword" : searchKeyword 
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var numOfRecords = response.getReturnValue();
                var numOfPages = Math.ceil(numOfRecords / pageSize);
                component.set("v.pageTotal", numOfPages);
                console.log('fetchCasePages Promise Resolved.', numOfPages);
                resolve();
            } else {
                console.error('Error fetching case total value.');
                reject('Error fetching case total value.');
            }
        });
    	$A.enqueueAction(action);
            
        });
    
        
        
    },
    
    fetchTZ: function(component){
        
        return new Promise((resolve, reject) => {
            
            var action = component.get("c.getUserTZ");
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log('fetchTZ Promise Resolved.');
                    var tz = response.getReturnValue();
                    console.log('the user timezone: ' + tz);        
                    component.set("v.localTZ",tz);
                    resolve();
     
                } else{
                    console.error('Error fetching logged in user time zone');
                    reject('Error fetching logged in user time zone');
                }
                           
        	});
        	$A.enqueueAction(action);
            
        });
 
    },
    
    //button click actions
    firstButtonClick: function(component, event, helper){
        
        //console.log('entered firstPage method.');
        
        this.setAttribute(component, "pageNumber", 1); 	//set page number
        //this.fetchCases(component);						//load data
        //this.setButtonVisibility(component);			//Enable/Disable buttons
        this.fetchData(component);
    },
    
    previousButtonClick: function(component, event, helper){
        
        console.log('Clicked Previous button.');
        
        let componentName = "pageNumber";
        let pageNumber = this.getAttribute(component,componentName);
        let nextPageNumber = Math.max(1, pageNumber - 1);
        
        
        console.log('Value prior to click: ', pageNumber);
        console.log('Expected value prior to click: ' + nextPageNumber);
        
        this.setAttribute(component, componentName, nextPageNumber);
        //console.log('Value after click: ' + getAttribute(component,"pageNumber"));
        
        this.fetchCases(component);
        this.setButtonVisibility(component);
        
    },
    
    nextButtonClick: function(component, event, helper){
        
        console.log('Clicked Previous button.');
        var pageNumber = component.get("v.pageNumber");
        
        console.log('Value prior to click: ', pageNumber);
        component.set("v.pageNumber", pageNumber + 1);
        
        console.log('Value after click: ', component.get("v.pageNumber"));
        
        this.fetchData(component);
        //this.setButtonVisibility(component);
        //this.fetchCases(component);
        
    },
    
    lastButtonClick: function(component, event, helper){
        
        let pageSize = this.getAttribute(component, "pageSize");
        let totalPages = this.getAttribute(component, "pageTotal");
        console.log('totalPages: ' + totalPages);
    
        this.setAttribute(component, "pageNumber", totalPages);
        //this.setButtonVisibility(component);
    	//this.fetchCases(component);
    	//
    	this.fetchData(component);
        
        
    },
    //end button click actions
    
    /*
     * functions to get and set component attributes.  
     * 
     * example: this.setAttribute(component, "pageNumber", 7); //sets pageNumber attribute on component to 7
     * example: let pageNumber = this.getAttribute(component, "pageNumber"); // declares variable pageNumber and populates with 7
     */
    
    getAttribute: function(component, attributeName){
        return component.get("v." + attributeName);
    },
    
    setAttribute: function(component, attributeName, attributeValue){
    	component.set("v." + attributeName, attributeValue);
	}
    
    
    

})