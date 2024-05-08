global without sharing class UserEmailFromTemplate {
    
    global class ParameterWrapper {
        
        @InvocableVariable(Label='Record Id' Required=true)
        public String recordId;
        
        @InvocableVariable(Label='Email Template Name' Required=true)
        public String templateName;
        
        @InvocableVariable(Label='Recipient User Colletion' Required=true)
        public user[] targetUsers;
        
        @InvocableVariable(Label='Org-Wide email address' Required=false)
        public String orgWide;
        
    }
    
    private static String QUERY_CASE = 'SELECT ContactId FROM Case WHERE Id = :recordId';
    private static String QUERY_TASK = 'SELECT OwnerId FROM Innova_ITSC_Task__c WHERE Id = :recordId';
    private static String QUERY_CHANGE = 'SELECT OwnerId FROM ChangeRequest WHERE Id = :recordId';
    
    private static String QUERY_ORG_WIDE = 'SELECT Address from OrgWideEmailAddress';
    private static Map<String,Id> orgWideMap;
    private static String platformUser;
    
    static Messaging.SingleEmailMessage[] emailsGlobal = new List<Messaging.SingleEmailMessage>();
    
    @InvocableMethod(Label='Send Email to User with Related Record')
    global static void RenderUserEmailWithObject(List<ParameterWrapper> passedData) {
        
        //Messaging.SingleEmailMessage[] emails = new List<Messaging.SingleEmailMessage>();
        System.debug('about to receive passed data: ' + passedData.size());
        
        for (ParameterWrapper dw : passedData) {
            
            
            RenderedEmail renderedEmail = new RenderedEmail(dw); 
            if(renderedEmail.hasError()) continue;
            /*
            Messaging.SingleEmailMessage[] emails = new List<Messaging.SingleEmailMessage>();
            
            emails.addAll(renderedEmail.getNewEmails());  //unknown number of emails returned.
            
 
            if(!Test.isRunningTest()) {
            //Messaging.SendEmailResult[] r = Messaging.sendEmail(emails);
                
            }
            */

        }
        
        if(!Test.isRunningTest() && emailsGlobal.size() > 0 ) {
            system.debug('about to send ' + emailsGlobal.size() + ' emails');
               Messaging.SendEmailResult[] r = Messaging.sendEmail(emailsGlobal);
            	emailsGlobal.clear();
            }
    }
    

    
    public class RenderedEmail{
        
        ParameterWrapper dw;
        
        Boolean errors = false;
        Messaging.SingleEmailMessage email;
        List<Messaging.SingleEmailMessage> newEmails = new List<Messaging.SingleEmailMessage>();
        SObject record;
        String recordId;
        EmailTemplate selectedTemplate;
        String templateName;
        String objectType;
        
        public RenderedEmail(ParameterWrapper dw){
        
            this.dw = dw;
            this.recordId = dw.recordId;
            this.templateName = dw.templateName;
            
            if( this.recordId == null || this.recordId == ''){ //no recordId passed
                this.errors = true;
            }
            
            setEmailTemplate();
            
            if( this.selectedTemplate == null){ //no email template by that name
                this.errors = true;
            } 
            
            setRecord();
            
            if( this.record == null ){
                this.errors = true;
            }
 
            setEmail();
            
            setNewEmails();
            
        }
        
        //public SObject getRecord(){
        //    return this.record;
        //}
        
        public Boolean hasError(){
            return this.errors;
        } 
        
        //public Messaging.SingleEmailMessage getEmail(){
        //    return this.email;
        //}
        
        //public List<Messaging.SingleEmailMessage> getNewEmails(){
        //    return this.newEmails;
        //}
        
        private void setNewEmails(){
            
            for(Integer i = 0; i < this.dw.targetUsers.size(); i++) {
                
                Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
                
                newEmail.setTargetObjectId(this.dw.targetUsers.get(i).id);
                newEmail.setSubject(email.getSubject());
                newEmail.setHTMLBody(email.getHTMLBody());
                newEmail.setOrgWideEmailAddressId(getOrgWideIdByEmail(this.dw.orgWide, this.objectType));
                newEmail.saveAsActivity = false;
                
                // 12/6/23
                // Include message id in the header.
                String messageId;
                
                if( this.objectType == 'Case' ){
                    messageId = Cases.generateThreadingMessageId(this.record.Id);
                    newEmail.setReferences(messageId);
                } 
                //HOW DO WE IMPLEMENT FOR CUSTOM OBJECTS??  A Task is related to a case, should we still use the Case reference?
                //if( this.objectType == 'Innova_ITSC_Task__c' ) messageId = Innova_ITSC_Task__c.generateThreadingMessageId(this.record.Id);
                   
                //this.newEmails.add(newEmail);
                emailsGlobal.add(newEmail);
                
                System.debug('adding to email list: ' + this.recordId);
               
                if(!Test.isRunningTest() && emailsGlobal.size() >= 90) {
                    Messaging.SendEmailResult[] r = Messaging.sendEmail(emailsGlobal);
                    emailsGlobal.clear();
                }
               
            }
            
        }
        
        private void setEmail(){ 
            
            Id templateId = this.selectedTemplate.Id;
            Id recipientId;
            
            if( this.objectType == 'Case' ) recipientId = (String)record.get('ContactId');
            if( this.objectType == 'Innova_ITSC_Task__c' ) recipientId = getPlatformUser();
            //if( this.objectType == 'ChangeRequest' ) recipientId = (String)record.get('OwnerId');
            
            this.email = Messaging.renderStoredEmailTemplate(templateId, recipientId, this.recordId);
        }
        
        private void setEmailTemplate(){
            
            try{
                this.selectedTemplate = [SELECT Id FROM EmailTemplate WHERE Name = :this.templateName limit 1];   
            } catch (Exception e){
                System.debug('Error when querying EmailTemplate for: ' + this.templateName);
            }
            
        }
        
        private void setRecord(){
            
            Id recId = (Id)this.recordId; //passed in from flow as a string.  cast to id to use getSObjectType method 
            this.objectType = recId.getSObjectType().getDescribe().getName();
            String query;
            
            switch on this.objectType{ 
                when 'Case' {                    
                    query = QUERY_CASE; 
                }               
                when 'Innova_ITSC_Task__c' {                  
                    query = QUERY_TASK;
                }
                when 'ChangeRequest' {
                    query = QUERY_CHANGE;
                }
                when else{
                    throw new UserEmailException('Unknown object type.  Only Case and ITSC Task is currently supported.');
                }
            }
        
            try{
                this.record = Database.query(query);    
            } catch ( System.QueryException qe ){
                //throw new UserEmailException( 'Error when querying Case object for Id: ' + recordId );
                System.debug( 'Error when querying ' + this.objectType + ' for Id: ' + recordId );
            }
        
            
        }
    }
    
    private static Id getPlatformUser(){
        
        if(platformUser == null){
            
            try{
                platformUser = [SELECT Id FROM User WHERE Name LIKE '%platform%' limit 1].Id;    
            } catch(Exception e){
                throw new UserEmailException('Unable to query for Platform Integration User.');
            }
            
        }
        
        return platformUser;
    }
    
    //lazy load org wide addresses
    public static Id getOrgWideIdByEmail(String emailAddress, String objectType){
        
        if(orgWideMap == null){
            orgWideMap = new Map<String,Id>();
            
            for(OrgWideEmailAddress o: Database.query(QUERY_ORG_WIDE)){
                orgWideMap.put(o.Address, o.Id);
                System.debug(o.Address);
            }
        }
        
        System.debug('--');
        System.debug('--');
        
        //Use a 'no-reply' mailbox if not a Case.  e.g., servicecloud.noreply@innovasolutions.com
        if(objectType != 'Case'){
            System.debug('Not Case object');
            emailAddress = 'servicecloud.noreply@innovasolutions.com';  
        } 
        
        if(orgWideMap.containsKey(emailAddress)){
            System.debug('contains email address?');
            return orgWideMap.get(emailAddress);  
        }
        
        System.debug('email address not found');
        return null;
    }
    
    public class UserEmailException extends Exception{}
}