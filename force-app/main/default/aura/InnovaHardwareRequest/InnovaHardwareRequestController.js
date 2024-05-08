({
    navigateToPage: function(component, event, helper) {
        var pageUrl = 'https://innovasolutionsitsc--partialsb.sandbox.my.site.com/Service/s/service-catalog-item';
        window.location.href = pageUrl;
    },
    navigateToAnotherPage: function(component, event, helper) {
        var pageUrl = 'https://innovasolutionsitsc--partialsb.sandbox.my.site.com/Service/s/service-request-for-hardware-';
        window.location.href = pageUrl;
    },
    navigatePage: function(component, event, helper) {
        var pageUrl = 'https://innovasolutionsitsc--partialsb.sandbox.my.site.com/Service/s/service-request-for-new-hire';
        window.location.href = pageUrl;
    },
    navigate: function(component, event, helper) {
        var pageUrl ='https://innovasolutionsitsc--partialsb.sandbox.my.site.com/Service/s/service-request-for-it-termination';
        window.location.href = pageUrl;
    },
    handleSelect: function(component, event, helper) {
        var selected = event.getParam('name');
        var caseBox = component.find('caseBox');
        var accBox = component.find('accBox');
        if (selected === 'reports_all') {
            component.set('v.showCreateaCase', true);
            component.set('v.showHardware', true); 
            component.set('v.showNewHire', true); 
            component.set('v.showTermination', true); 
            
        }   
        if (selected === 'reports_General') {
            component.set('v.showCreateaCase', true);
            component.set('v.showHardware', false); 
            component.set('v.showNewHire', false); 
            component.set('v.showTermination', false); 
            
        }   
        if (selected === 'reports_tickets') {
            component.set('v.showCreateaCase', false);
            component.set('v.showHardware', true); 
            component.set('v.showNewHire', false); 
            component.set('v.showTermination', false); 
        } 
        if (selected === 'reports_articles') {
            component.set('v.showCreateaCase', false);
            component.set('v.showHardware', false); 
            component.set('v.showNewHire', true); 
            component.set('v.showTermination', true); 
        } 
    }
})