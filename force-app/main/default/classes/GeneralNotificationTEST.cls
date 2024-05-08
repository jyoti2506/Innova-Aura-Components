@isTest
public class GeneralNotificationTEST {
    
    
    @isTest static void TaskInsert() {
        
        Innova_ITSC_Task__c t = new Innova_ITSC_Task__c();
        t.OwnerId = [Select Id from Group Where Type = 'Queue' And Name = 'Service Cloud' limit 1].Id;
        
        insert t;
    }
    
    @isTest static void TaskUpdate() {
        
        Innova_ITSC_Task__c t = new Innova_ITSC_Task__c();
        t.OwnerId = [Select Id from Group Where Type = 'Queue' And Name = 'Service Cloud' limit 1].Id;
        
        insert t;
        
        t = [Select Id from Innova_ITSC_Task__c Where Id = :t.Id];
        
        t.OwnerId = System.UserInfo.getUserId();
        
        update t;
    } 
    
    @isTest static void CaseInsert(){
        
        Case c = new Case();
        
        c.OwnerId = [Select Id from Group Where Type = 'Queue' And Name = 'Service Cloud' limit 1].Id;
        c.RecordTypeId = [Select Id from RecordType Where SobjectType = 'Case' And Name = 'Incident' limit 1].Id;
        c.Description = 'test desc';
        
        insert c;
    }
    
    @isTest static void CaseUpdate(){
        
        Case c = new Case();
        c.OwnerId = [Select Id from Group Where Type = 'Queue' And Name = 'Service Cloud' limit 1].Id;
        
        insert c;
        
        c = [Select Id from Case Where Id = :c.Id];
        
        c.OwnerId = System.UserInfo.getUserId();
        
        update c;
    }

}