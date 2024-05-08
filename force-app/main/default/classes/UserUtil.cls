/*
 * This class IS NOT ready for production.
 * Must add try/catch, etc. 
*/

public class UserUtil {
    
    public static Id getContactIdByUserId(Id userId){
        
        Id accountId = getAccountIdByUserId(userId);
        Id contactId = getContactIdByAccountId(accountId);
        
        return contactId;
    }
    
    public static Id getAccountIdByUserId(Id userId){
        
        //query employee where userId = userId
        //return relatedpersonid
        
        Employee e = [SELECT RelatedPersonId FROM Employee WHERE UserId = :userId limit 1];
        
        return e.RelatedPersonId;
    }
    
    public static Id getContactIdByAccountId(Id accountId){
        
        Account a = [SELECT PersonContactId FROM Account WHERE Id = :accountId limit 1];
        return a.PersonContactId;
    }
    
    public class UserUtilException extends Exception{}

}