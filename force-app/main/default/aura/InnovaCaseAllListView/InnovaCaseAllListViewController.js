({
    doInit: function(component, event, helper) {
        
      //component.set('v.isLoading', true);
        helper.fetchData(component);
        //uses promises to get data from server first, and then set button visibility
        //helper.fetchCases(component)
       // 	.then(() => helper.fetchCasePages(component))
       // 	.then(() => helper.fetchTZ(component))
       // 	.then(() => helper.setButtonVisibility(component))
       // .catch(error => console.error('Error in Promise Chain:', error)); 

    },
    
    onAfterRender: function(component, event, helper){
        //helper.setButtonVisibility(component);
    },
    
   
    firstPage: function(component, event, helper) {       
        helper.firstButtonClick(component, event, helper);     
    },
    
    //Previous Button action
    previousPage: function(component, event, helper) {
        helper.previousButtonClick(component, event, helper);    
    },
    
    
    
    lastPage: function(component, event, helper) {
    	helper.lastButtonClick(component, event, helper);
	},
    
    
    nextPage: function(component, event, helper) {  
        helper.nextButtonClick(component, event, helper);
    },
    
    searchByKeyword: function (component, event, helper) {
        
        var searchKeyword = component.find('searchField').get('v.value');
        component.set('v.searchKeyword', searchKeyword);
        component.set('v.pageNumber', 1); //set first page after every search
 
        helper.fetchData(component);
    },
  
    
});