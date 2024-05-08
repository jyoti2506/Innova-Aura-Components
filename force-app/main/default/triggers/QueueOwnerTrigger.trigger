trigger QueueOwnerTrigger on Innova_Queue_Owner__c (before insert, before update) {

    if(Trigger.isInsert){
        if(Trigger.isBefore) QueueOwnerHandler.BeforeInsert(Trigger.new);
        //if(Trigger.isAfter) QueueOwnerHandler.AfterInsert(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore) QueueOwnerHandler.BeforeUpdate(Trigger.new, Trigger.oldMap);
        //if(Trigger.isAfter) QueueOwnerHandler.AfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}