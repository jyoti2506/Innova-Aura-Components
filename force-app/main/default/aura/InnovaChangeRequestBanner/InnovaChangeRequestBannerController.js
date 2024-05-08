({
    doInit: function(component, event, helper) {   
        var id = component.get("v.recordId");
        var viewportWidth = window.innerWidth;
        var contentDiv = component.find('contentDiv');
        
        // Check the viewport width and apply styles dynamically
        if (viewportWidth <= 600) {
            $A.util.addClass(contentDiv, 'slds-col slds-size_1-of-1');
        } else {
            // Remove the class if the viewport width is larger than 600px
            $A.util.removeClass(contentDiv, 'slds-col slds-size_1-of-1');
        }
        helper.getFieldSet(component,event,helper);
        
    },
})