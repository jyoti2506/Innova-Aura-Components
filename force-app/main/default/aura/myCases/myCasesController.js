({
    //Method call on load of Lightning Component
    doInitHelper : function(component,event){
        //Initialize the columns for data table
        component.set('v.columns',[
            {
                label : 'Name',
                fieldName : 'recordId',
                type : 'url',
                typeAttributes : {label:{fieldName:'recordName'},target:'_blank'}
            },
            {
                label : 'Submitted date',
                fieldName : 'submittedDate',
                type : 'date',
                typeAttributes : {	day: "2-digit",
    								month: "2-digit",
                                    year: "numeric",
                                    hour: "2-digit",
                                    minute: "2-digit",
                                    hour12: true
                                 },
                sortable : true
            },
            {
                label : 'Title',
                fieldName : 'subject',
                type : 'text',
                sortable : true
            },
            {
                label : 'Submitted By',
                fieldName : 'relatedTo',
                type : 'text',
                sortable : true
            },  
            {
                label : 'Assigned To',
                fieldName : 'submittedBy',
                type : 'text',
                sortable : true
            },
            {
                label : 'Status',
                fieldName : 'status',
                type : 'text',
                sortable : true
            }
        ]);
        this.getData(component,event);
    },
    
    //Method to fetch data
    getData : function(component,event){
        //show spinner till data is loaded from server
        var spinner = component.find("spinnerId");
        $A.util.toggleClass(spinner, "slds-hide");
        var toastRef = $A.get('e.force:showToast');
        var action = component.get('c.getSubmittedRecords');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.recordId = '/'+record.recordId;
                });
                $A.util.toggleClass(spinner, "slds-hide");
                if(records.length == 0){
                    component.set("v.isModalOpen", false);
                    component.set("v.showMessage", true);
                }
                else{
                    component.set("v.showApprovalComponent", true);
                }
                component.set('v.data',records);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Method to handle sorting of records
    handleSortingOfRows : function(component,event){
        //Set field name and direction of sorting
        console.log('sort time!');
        var sortedBy = event.getParam('fieldName');
        var sortedDirection = event.getParam('sortDirection');
        component.set('v.sortedBy',sortedBy);
        component.set('v.sortedDirection',sortedDirection);
        this.sortRecords(component,event,sortedBy,sortedDirection);
    },
    
    //Method to handle sorting of records
    sortRecords : function(component,event,sortedBy,sortedDirection){
        var records = component.get('v.data');
        var direction = sortedDirection == 'asc' ? 1 : -1;
        var fieldValue = function(record){ return record[sortedBy]; }//returns the field value(field used for sorting) for each record
        records.sort(function(record1,record2){
            var fieldValue1 = fieldValue(record1);
            var fieldValue2 = fieldValue(record2);
            return direction * (fieldValue1 > fieldValue2) - (fieldValue2 > fieldValue1);//For asc,return value of -1 sorts the record,1 or 0 keeps the order intact.
        });
        console.log('sort time over');
        component.set('v.data',records);
    },
    
    //Method to enable or disable Approve and Reject button
    handleRowSelection : function(component,event,helper){
        //To enable or disable Approve, Reject button based on row selection
        var rowsSelected = event.getParam('selectedRows');
        if(rowsSelected.length > 0){
            component.find('approvalButtonId').set('v.disabled',false);
            component.find('rejectButtonId').set('v.disabled',false);
        }
        else{
            component.find('approvalButtonId').set('v.disabled',true);
            component.find('rejectButtonId').set('v.disabled',true);
        }
    },
    
    //Method to Approve or Reject the selected records
    processSelectedRecords : function(component,event,helper,processType){
        //To approve, reject selected records based on 'processType' variable
        component.find('approvalButtonId').set('v.disabled',true);
        component.find('rejectButtonId').set('v.disabled',true);
        var selectedRows = component.find('approvalRecordsTableId').get('v.selectedRows');
        var action = component.get('c.processRecords');//Calling server side method with selected records
        action.setParams({
            lstWorkItemIds : selectedRows,
            processType : processType,
            commentFromUser : component.get("v.comment")
            
        });
        action.setCallback(this,function(response){
            $A.get('e.force:refreshView').fire();
            var state = response.getState();
            var toastRef = $A.get('e.force:showToast');
            if(state == 'SUCCESS'){
                var message = response.getReturnValue();
                if(message.includes('success')){
                    toastRef.setParams({
                        'type' : 'success',
                        'title' : 'Success',
                        'message' : message,
                        'mode' : 'dismissible'
                    });
                }
                else{
                    toastRef.setParams({
                        'type' : 'error',
                        'title' : 'Error',
                        'message' : message,
                        'mode' : 'sticky'
                    });
                }
                toastRef.fire();
                location.reload();
            }
        });
        $A.enqueueAction(action);
        
    }
})