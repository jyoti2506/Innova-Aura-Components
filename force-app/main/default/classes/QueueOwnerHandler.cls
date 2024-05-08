public class QueueOwnerHandler {
    

    public static void BeforeInsert(List<Innova_Queue_Owner__c> triggerDotNew){
        
        for(Innova_Queue_Owner__c qo: triggerDotNew){
            new QueueOwnerCheck(qo).setPublicGroupId();  
        }
        
    }
    
    public static void BeforeUpdate(List<Innova_Queue_Owner__c> triggerDotNew, Map<Id,Innova_Queue_Owner__c> triggerDotOldMap){
        
        for(Innova_Queue_Owner__c qo: triggerDotNew){
            new QueueOwnerCheck(qo).setPublicGroupId();  
        }
        
    }
    
    /*
    public static void AfterInsert(List<Innova_Queue_Owner__c> triggerDotNew, Map<Id,Innova_Queue_Owner__c> triggerDotOldMap){
        //not implemented
    }
    
    public static void AfterUpdate(List<Innova_Queue_Owner__c> triggerDotNew, Map<Id,Innova_Queue_Owner__c> triggerDotOldMap){
        //not implemented
    }
    */


}