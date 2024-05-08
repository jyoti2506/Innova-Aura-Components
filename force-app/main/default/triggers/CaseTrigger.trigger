trigger CaseTrigger on Case (before insert, before update) {
    
    if(Trigger.isInsert){
        if(Trigger.isBefore) CaseHandler.BeforeInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore) CaseHandler.BeforeUpdate(Trigger.new, Trigger.oldMap);
    }

}