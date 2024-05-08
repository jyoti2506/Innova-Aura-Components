@isTest
public class EmailMessageHandler_TEST {
    
    @isTest static void testToAddress(){
        
        Case c = new Case();
        c.Description = 'test desc';
        c.Origin = 'Email';
        insert c;
        
        Id caseId = [Select Id from Case Where Id =: c.Id limit 1].Id;
        
        EmailMessage m = new EmailMessage();
        m.ToAddress = 'test@test.com';
        m.ParentId = caseId;
        
        insert m;
        
        c = [Select To_Address__c from Case Where Id =: c.Id limit 1];
        
        System.assertEquals('test@test.com', c.To_Address__c);
    }

}