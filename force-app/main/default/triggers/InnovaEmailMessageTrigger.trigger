trigger InnovaEmailMessageTrigger on EmailMessage (after insert) {
    
    if(Trigger.isInsert){
        if(Trigger.isAfter) EmailMessageHandler.AfterInsert(Trigger.new);
    }

}