public class approvalController {
    //Method to fetch all the records which are submitted for approval
    
    private static List<ProcessInstance> processInstanceList;
    
    private static Map<Id,SObject> recordMap = new Map<Id,SObject>();
    
    private static List<SubmittedRecordsWrapper> lstSubmissionWrapper = new List<SubmittedRecordsWrapper>();
    //private static String query;
    private static List<sObject> queryList = new List<sObject>();
    
    private static Set<Id> targets = new Set<Id>();
    private static Set<String> objects = new Set<String>();
    
    private static List<String> varQueueNames = new List<String>();
    
    @AuraEnabled
    public static List<SubmittedRecordsWrapper> getSubmittedRecords(){
        
        //get all approvals for user
        //get record details for each approval
        //
        
        
        //Process instance stores the info of records submitted for approval,
        // Process instance work item are the records an approver sees while approving/rejecting, Process instance step stores approved/rejected record including approva;/rejection comments
        
        
        Id userId = System.UserInfo.getUserId();
        
        List<GroupMember> gmList = [select id, UserOrGroupId, GroupId from GroupMember Where Group.Type = 'Queue' Or Group.Type = 'Group']; 
        
        for(GroupMember gm: gmList){
            if(gm.UserOrGroupId == userId) varQueueNames.add(gm.GroupId);
		}
        
        system.debug('Queue ids are --->' + varQueueNames);
        
        setTargets();
        setRecords();
        

        for(ProcessInstance ps : getProcessInstances()){
            if(!ps.StepsAndWorkitems.isEmpty()){
                system.debug('ps.WorkItems'+ps.StepsAndWorkitems);
                
                addToWrapper(ps);
  
            }
        }
        System.debug( 'Queries: ' + Limits.getQueries() );
        
        return lstSubmissionWrapper;
    }
    
    /*
    public static String getObjectLabel(String recordId){
        //To get the label of the object name using Schema methods
        String keyPrefix = recordId.subString(0,3);
        String objectName = '';
        Map<String,Schema.SObjectType> sobjectTypeMap = Schema.getGlobalDescribe();
        for(String obj : sobjectTypeMap.keySet()){
            Schema.DescribeSObjectResult sobjectResult = sobjectTypeMap.get(obj).getDescribe();
            if(sobjectResult.getKeyPrefix() == keyPrefix){
                objectName = sobjectResult.getName();
                break;
            }
        }
        return objectName;
    }*/
    
    //return the name of the object based on record id
    public static String getObjectLabel(String recordId){
        Id tempRecordId = recordId;
        return tempRecordId.getSObjectType().getDescribe().getName();
    }
    
    //Method to Approve or Reject the selected records
    @AuraEnabled
    public static String processRecords(List<String> lstWorkItemIds,String processType, String commentFromUser){
        String message = '';
        Integer recordsProcessed = 0;
        String comments = commentFromUser;
        
        List<Approval.ProcessWorkitemRequest> lstWorkItemRequest = new List<Approval.ProcessWorkitemRequest>();//ProcessWorkitemRequest class has methods to programmatically process submitted records
        for(String workItemId : lstWorkItemIds){
            Approval.ProcessWorkitemRequest objWorkItemRequest = new Approval.ProcessWorkitemRequest();
            objWorkItemRequest.setComments(comments);
            objWorkItemRequest.setAction(processType);//approve or reject
            objWorkItemRequest.setWorkitemId(workItemId);
            lstWorkItemRequest.add(objWorkItemRequest);
        }
        Approval.ProcessResult[] lstProcessResult = Approval.process(lstWorkItemRequest,FALSE);//process method is used for approving/rejecting records depending on setAction attribute
        system.debug('approval list ---' + lstProcessResult);
        for(Approval.ProcessResult processResult : lstProcessResult){
            if(processResult.isSuccess()){
                recordsProcessed++;
            }
            else{
                for(Database.Error error : processResult.getErrors()){
                    message += error.getMessage();
                }
            }
        }
        if(recordsProcessed == lstWorkItemIds.size()){
            if(processType=='Approve'){
                message = 'All records are '+ processType +'d successfully';
            }
            else {
                message = 'All records are '+ processType +'ed successfully';
            }
            
        }
        return message;
    }
    
    
    
    private static List<ProcessInstance> getProcessInstances(){
        
        if(processInstanceList == null){ //lazy load
            
             processInstanceList = new List<ProcessInstance>();
            
            try{
            processInstanceList = [SELECT Id, 
                      CreatedDate,
                      SubmittedById, 
                      SubmittedBy.Name, 
                      	(SELECT Id,
                         CreatedDate, 
                         TargetObjectId, 
                         StepStatus,
                         Actorid,
                         Actor.Name, 
                         Comments 
                         FROM StepsAndWorkitems 
                         Where StepStatus = 'Pending' AND (Actorid = :UserInfo.getUserId() OR Actorid IN :varQueueNames)),
                      TargetObject.Name, 
                      TargetObject.Type, 
                      TargetObjectId, 
                      Status, 
                      LastActorId 
                      
                      FROM ProcessInstance WHERE Status = 'Pending'];
                      
            } catch(Exception e){
                System.debug('Unable to execute approvals query.');
            }
        }
       
        return processInstanceList;
    }
    
    private static void setTargets(){
        
        for( ProcessInstance pi: getProcessInstances() ){
            targets.add(pi.TargetObjectId);
            
            System.debug('updated name: ' + pi.TargetObjectId.getSObjectType().getDescribe().getName());
            //objects.add(getObjectLabel(pi.TargetObjectId));
            objects.add(pi.TargetObjectId.getSObjectType().getDescribe().getName());
        }
        System.debug('the object set: ' + objects);
        
    }
    
    private static void setRecords(){
        
        String query;
        
        for(String objectName: objects){
            
            if( objectName.contains('__c') ) {
            	query= 'SELECT Id, Innova_Subject__c, Innova_Status__c FROM ' + objectName + ' WHERE Id in: targets';
        	} else if ( objectName.contains('Knowledge') ){
                query = 'SELECT Id, ArticleNumber,PublishStatus FROM Knowledge__ka Where Id in: targets';
            } else if( objectName == 'ChangeRequest'){ //added because Change Request is now being used
                query = 'SELECT Id, Subject, Status,Contact_Name__c from ChangeRequest Where Id IN: targets';
            }
            	else{
                query = 'SELECT Id, Subject,ContactId, Status FROM ' + objectName + ' WHERE Id in: targets'; 
                    system.debug('Line183'+query);
            } 
            
            for(SObject s: Database.query(query)){
            	recordMap.put(s.Id,s);
        	}
        system.debug('line187'+recordMap);
        }
    }
    
    public static void addToWrapper(ProcessInstance ps){
        
        if( ps.StepsAndWorkitems.isEmpty() ) return;
       
        
        Id recordId = ps.TargetObjectId;
        String objectName = getObjectLabel(ps.TargetObjectId);
        String subjectField;
        String recordNameField;
        
        SubmittedRecordsWrapper objSubmittedRecordsWrapper = new SubmittedRecordsWrapper();
        
        objSubmittedRecordsWrapper.workItemId = ps.StepsAndWorkitems[0].Id; 
        objSubmittedRecordsWrapper.recordId = recordId;
        objSubmittedRecordsWrapper.recordName = ps.TargetObject.Name;
        objSubmittedRecordsWrapper.relatedTo = ps.SubmittedBy.Name;
        
        
        
        
        objSubmittedRecordsWrapper.submittedDate = ps.CreatedDate;
        
        objSubmittedRecordsWrapper.submittedBy = ps.StepsAndWorkitems[0].Actor.Name;
        String recordName = ps.TargetObject.Name;
        System.debug('Name: ' + recordName);
        
      

        if(objectName.contains('__c')) {
            objSubmittedRecordsWrapper.subject = (String)recordMap.get(recordId).get('Innova_Subject__c');
            objSubmittedRecordsWrapper.status = (String)recordMap.get(recordId).get('Innova_Status__c');
            
        
        }
        else if(objectName.contains('Knowledge')){
    
            objSubmittedRecordsWrapper.subject = ps.TargetObject.Name;
            objSubmittedRecordsWrapper.status = (String)recordMap.get(recordId).get('PublishStatus');
            objSubmittedRecordsWrapper.recordName = (String)recordMap.get(recordId).get('ArticleNumber');
        }
        
        //added because Change Request is now being used
        else if(objectName.contains('ChangeRequest')){
            objSubmittedRecordsWrapper.subject = (String)recordMap.get(recordId).get('Subject');
            objSubmittedRecordsWrapper.status = (String)recordMap.get(recordId).get('Status');
        }
        
        else{           
            objSubmittedRecordsWrapper.subject = (String)recordMap.get(recordId).get('Subject');
            objSubmittedRecordsWrapper.status = (String)recordMap.get(recordId).get('Status');
            System.debug('object name map: ' + objectName);
            objSubmittedRecordsWrapper.Contact = (String)recordMap.get(recordId).get('ContactId');
           
        }
        
        System.debug('wrapper: ' + objSubmittedRecordsWrapper);
        lstSubmissionWrapper.add(objSubmittedRecordsWrapper);
        
    }
        
    //Wrapper class to store the column values of data table
    public class SubmittedRecordsWrapper{
        @AuraEnabled public Id workItemId;
        @AuraEnabled public String recordId;
        @AuraEnabled public String relatedTo;
        @AuraEnabled public String recordName;
        @AuraEnabled public String submittedBy;
        @AuraEnabled public Datetime submittedDate;
        @AuraEnabled public String subject;
        @AuraEnabled public String status;
        @AuraEnabled public String Contact;
       
    }
}