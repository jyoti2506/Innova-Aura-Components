public without sharing class changeRequestController {
    
    @AuraEnabled
    public static String getChangeRequestBannerData(String recordId){
        
        System.debug('recordId: ' + recordId);
        ChangeRequest cr = [SELECT ChangeRequestNumber, Subject, Status,Created_By_Full_Name__c FROM ChangeRequest WHERE Id = :recordId LIMIT 1];
        
        if ( cr == null ) return '[]'; 
            
        String returnValue = '[{"label":"Change Request#","value":"' +  (cr.ChangeRequestNumber !=null ? cr.ChangeRequestNumber : '') + '"},{"label":"Status","value":"' +  (cr.Status !=null ? cr.Status : '') + '"},{"label":"Subject","value":"' + (cr.Subject  !=null ? cr.Subject  : '') + '"},{"label":"Created By","value":"' +  (cr.Created_By_Full_Name__c  !=null ? cr.Created_By_Full_Name__c  : '')  + '"}]';
        System.debug('returnValue: ' + returnValue);    
        
        return returnValue;
        
	}
    

    @AuraEnabled
    public static String getChangeRequestDetail(String recordId){
        
        System.debug('search for ChangeRequest by Id: ' + recordId);
           
        ChangeRequest cr = [SELECT Subject,Description, Priority,Category,Impact,Implementation_Plan__c,Test_Plan__c,Roll_Back_Plan__c FROM ChangeRequest WHERE Id = :recordId LIMIT 1];
            
        if( cr == null ) return '[]';
        
        String returnValue = '[{"label":"Subject","value":"' + (cr.Subject !=null ? cr.Subject : '') + '"},{"label":"Description","value":"' + (cr.Description !=null ? cr.Description :'') + '"},{"label":"Category","value":"' + (cr.Category!=null ? cr.Category :'') + '"},{"label":"Priority","value":"' + (cr.Priority !=null ? cr.Priority  :'') + '"},{"label":"Impact","value":"' +  (cr.Impact !=null ? cr.Impact  :'') + '"},{"label":"Implementation Plan","value":"' +  (cr.Implementation_Plan__c !=null ? cr.Implementation_Plan__c  :'') + '"},{"label":"Test Plan","value":"' + (cr.Test_Plan__c !=null ? cr.Test_Plan__c :'') + '"},{"label":"Roll Back Plan","value":"' +  (cr.Roll_Back_Plan__c !=null ? cr.Roll_Back_Plan__c :'')+ '"}]';
        System.debug('returnValue: ' + returnValue);
        
        return returnValue;
    }   
    
    @AuraEnabled
    public static ChangeRequest getChangeRequest(String recordId){
        
        return [SELECT Subject FROM ChangeRequest WHERE Id = :recordId LIMIT 1];
        
    }
  
  
}