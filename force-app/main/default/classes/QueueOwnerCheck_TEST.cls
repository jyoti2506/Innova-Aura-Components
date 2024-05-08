@isTest
public class QueueOwnerCheck_TEST {
    
    @isTest static void testInsert_PublicGroupValidation(){
        
        Group g = [Select Name from Group Where Name = 'Service Desk' And Type = 'Regular' limit 1];
        
        Innova_Queue_Owner__c qo = new Innova_Queue_Owner__c();
        qo.Innova_Public_Group_Escalation__c = g.Name;
        
        insert qo;
        
    }
    
    @isTest static void testUpdate_PublicGroupValidation(){
        
        Group g = [Select Name from Group Where Name = 'Service Desk' And Type = 'Regular' limit 1];
        
        Innova_Queue_Owner__c qo = new Innova_Queue_Owner__c();
        qo.Innova_Public_Group_Escalation__c = g.Name;
        
        insert qo;
        
        qo = [Select Id from Innova_Queue_Owner__c limit 1];
        qo.Queue_Name__c = 'test';
        update qo;
        
    }
    
    @isTest static void testError(){
        
        Innova_Queue_Owner__c qo = new Innova_Queue_Owner__c();
        qo.Innova_Public_Group_Escalation__c = 'does not exist';
        
        Boolean isError = false;
        
        try{
        	insert qo;	    
        } catch (Exception e){
            isError = true;
        }
        
        System.assertEquals(true,isError);
        
    }

}