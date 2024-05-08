({
    doInit : function(component, event, helper) {
        // Initialization code can be added here if needed
    },

    handleClick : function(component, event, helper) {
        // Get the article URL
        var articleUrl = helper.articleUrl(component);

        // Use the lightning/navigation service to navigate to the article URL
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__webPage',
            attributes: {
                url: articleUrl
            }
        };
        
        navService.navigate(pageReference);
    }
})