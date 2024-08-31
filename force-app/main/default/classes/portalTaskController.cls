public class portalTaskController {

    @AuraEnabled
    public static String getTaskBannerData(String recordId){
        
        System.debug('recordId: ' + recordId);
        Innova_ITSC_Task__c t = [SELECT Name, Innova_Subject__c, Innova_Status__c,Created_By_Full_Name__c FROM Innova_ITSC_Task__c WHERE Id = :recordId LIMIT 1];
        
        if ( t == null ) return '[]'; 

        String name = t.Name != null ? t.Name : '';
        String status = t.Innova_Status__c != null ? t.Innova_Status__c : '';
        String subject = t.Innova_Subject__c  != null ? t.Innova_Subject__c : '';
        String createdByFullName = t.Created_By_Full_Name__c  != null ? t.Created_By_Full_Name__c : '';
            
        String returnValue = '[{"label":"Task #","value":"' + name + '"},{"label":"Status","value":"' + status + '"},{"label":"Subject","value":"' + subject + '"},{"label":"Created By","value":"' + createdByFullName + '"}]';
        System.debug('returnValue: ' + returnValue);    
        
        return returnValue;
        
    }
    
    @AuraEnabled
    public static String getTaskDetail(String recordId){
        
        System.debug('search for Task by Id: ' + recordId);
           
        Innova_ITSC_Task__c t = [SELECT Innova_Subject__c, Innova_Task_Notes__c, Case_Title__c FROM Innova_ITSC_Task__c WHERE Id = :recordId LIMIT 1];
            
        if( t == null ) return '[]';

        String subject = t.Innova_Subject__c != null ? t.Innova_Subject__c : '';
        String notes = t.Innova_Task_Notes__c != null ? t.Innova_Task_Notes__c : '';
        String caseTitle = t.Case_Title__c != null ? t.Case_Title__c : '';
        
        String returnValue = '[{"label":"Subject","value":"' + subject+ '"},{"label":"Notes","value":"' + notes + '"},{"label":"Case Title","value":"' + caseTitle + '"}]';
        System.debug('returnValue: ' + returnValue);
        
        return returnValue;
        
    }
    
    @AuraEnabled
    public static Innova_ITSC_Task__c getTask(String recordId){
        
        return [Select Innova_Subject__c from Innova_ITSC_Task__c Where Id = :recordId];
    }
}