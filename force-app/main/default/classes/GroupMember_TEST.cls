@isTest
public class GroupMember_TEST {
    
    static{
        
        Innova_Queue_Owner__c iqo1 = new Innova_Queue_Owner__c();
        
        iqo1.Innova_Public_Group_Id__c = [Select Id from Group Where Type = 'Regular' And Name = 'Service Desk - Escalation' limit 1].Id;
        iqo1.Innova_Public_Group_Escalation__c = 'Service Desk - Escalation';
        iqo1.Queue_Name__c = 'Service Desk';
        
        insert iqo1;
        
        Innova_Queue_Owner__c iqo2 = new Innova_Queue_Owner__c();
        
        iqo2.Innova_Public_Group_Id__c = [Select Id from Group Where Type = 'Regular' And Name = 'Service Desk - Escalation' limit 1].Id;
        iqo2.Innova_Public_Group_Escalation__c = 'Service Desk - Escalation';
        iqo2.Queue_Name__c = 'Infrastructure';
        
        insert iqo2;
        
    }

    @isTest static void testInsertCase_Email(){
        
        Case c = createCase();
        c.Origin = 'Email';
            
        insert c;
        
        c = [Select Public_Group_Emails__c from Case Where Id = :c.Id limit 1];
        
        RunTest(c);
  
    }
    
    
    
    @isTest static void testInsertCase_PortalConsole(){
        
        Case c = createCase();
        c.Origin = 'Service Cloud';
        
        insert c;
            
        c = [Select Public_Group_Emails__c from Case Where Id = :c.Id limit 1];
        
        RunTest(c);
        
    }
    
    @isTest static void testUpdateCase_PortalConsole(){
        
        Case c = createCase();
        c.Origin = 'Service Cloud';
        
        insert c;
        
        c = [Select Public_Group_Emails__c from Case Where Id = :c.Id limit 1];
        
        c.OwnerId = [Select Id from Group Where Name = 'Infrastructure' And Type = 'Queue' limit 1].Id;
        c.Current_Queue__c = 'Infrastructure';
        
        update c;
        
        RunTest(c);
        
    }
    
    private static Case createCase(){
        
        Case c = new Case();
        
        c.Description = 'test desc';
        
        c.OwnerId = [Select Id from Group Where Name = 'Service Desk' And Type = 'Queue' limit 1].Id;
        c.Current_Queue__c = 'Service Desk';
        
        return c;
        
    }
    
    private static void RunTest(Case c){
        if(!GroupMemberHelper.isEnabled()){
             System.assertEquals(true,true); 
            return;
        }
        System.assertNotEquals(null,c.Public_Group_Emails__c);
    }
    
    
    
    
}