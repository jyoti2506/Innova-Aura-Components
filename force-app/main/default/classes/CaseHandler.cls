public class CaseHandler {
       
    /*
    public static void BeforeInsert(List<Case> triggerDotNew){
                
        List<Case> casesWithEmails = [Select Id, CaseNumber, (Select FromAddress from Emails) From Case Where Id IN: triggerDotNew];
                    
        for(Case c: casesWithEmails){      
            
            if( c.Origin != 'Email') continue; //only email to case
            if( c.ContactId != null ) continue; //only if contact not found
            
            List<EmailMessage> emailMessages = c.Emails;
            
            if(emailMessages == null) continue;
            
            c.Sender_Email_Address__c = emailMessages[0].FromAddress;
            
        }
        
    }*/
    
    public static void BeforeInsert(List<Case> triggerDotNew){
        
        for(Case c: TriggerDotNew){
            
            if(!GroupMemberHelper.isEnabled()) continue;
            
            //todo - move all logic to an EscalationEmailProcessor class.
            String owner = c.OwnerId;
            
            if(owner.startsWith('005')) continue;
            
            
            GroupMemberHelper gmh = new GroupMemberHelper(c.OwnerId);
            String publicGroupId = gmh.getPublicGroupId();
            
            String emails = gmh.getEmails(publicGroupId);
            
            if(emails!= null && emails!= '') c.Public_Group_Emails__c = emails;
        }
        
    }
    
    public static void BeforeUpdate(List<Case> TriggerDotNew, Map<Id,Case> TriggerDotOldMap){
        
        for(Case c: TriggerDotNew){
            
            if(!GroupMemberHelper.isEnabled()) continue;
            
            //todo - move all logic to an EscalationEmailProcessor class.
            String owner = c.OwnerId;
            
            if(owner.startsWith('005')) continue;
            
            
            Case oldRecord = TriggerDotOldMap.get(c.Id);
            if(oldRecord.OwnerId == c.OwnerId) continue;
            
            GroupMemberHelper gmh = new GroupMemberHelper(c.OwnerId);
            String publicGroupId = gmh.getPublicGroupId();
            
            String emails = gmh.getEmails(publicGroupId);
            
            if(emails!= null && emails!= '') c.Public_Group_Emails__c = emails;
        }
        
    }
        
}