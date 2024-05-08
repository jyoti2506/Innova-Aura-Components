/*
 * When is the   
 */
public class InnovaEmailProcessor {
    
    Map<String,String> caseEmailMap = new Map<String,String>(); //put in a map so ParentId/Case.Id is unique
    
    
    public static Boolean isEnabled(){
        
        String isEnabled = 'false';

        try{
        	isEnabled = [Select Value__c From Innova_EmailMessage__mdt Where DeveloperName = 'Active' limit 1].value__c;    
        } catch (Exception e){
            System.debug('Unable to query Innova_EmailMessage__mdt custom metadata type.  Will not run.');
            return false;
        }
		

        if(isEnabled != null && isEnabled.toLowerCase() == 'true') return true;
        return false;
    }
    
    public InnovaEmailProcessor(List<EmailMessage> triggerDotNew){
        
        if(!isEnabled()) return;
        
        
        //loop through new emails added.  Put in caseEmailMap.
        for(EmailMessage email: triggerDotNew){
             caseEmailMap.put(email.ParentId,email.ToAddress);  
        }
        
        
        List<Case> caseList = new List<Case>();
        
        //loop through cases that had an email added.
        //if email is linked to a case created from email, and does not have a contact, populate sender email field.
        for(Case c: [Select Origin, ContactId from Case Where Id IN :caseEmailMap.keySet() ]){
            
            if( c.Origin != 'Email') continue; //only email to case
            if( c.ContactId != null ) continue; //only if contact not found
            
            if(caseEmailMap.get(c.Id) != null){
                c.To_Address__c = caseEmailMap.get(c.Id).left(1000);
                caseList.add(c);
            }

        }
        
        
        List<Database.SaveResult> srList = Database.update(caseList);
        
        for(Database.SaveResult sr : srList){
            
            if(sr.isSuccess()){
            	System.debug('Updated case with sender email address.');
        	} else {
            
                for(Database.Error e : sr.getErrors()){
                    System.debug('Unable to update the Case with sender email address. ' + e.getMessage());
                }
        	}
           
        }
    
    }
    
}