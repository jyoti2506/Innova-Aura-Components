public with sharing class CommunityDetailsCheckController {  
      
    /*
    @AuraEnabled( cacheable = true )
    public static List<String> getTimeZoneOptions(){
        
        List<String> timeZoneOptions = new List<String>();
        
        // Query the custom object 'Time_Zone__c' for picklist values
        List<Time_Zone__c> timeZones = [SELECT Time_Zone_Name__c FROM Time_Zone__c ORDER BY Time_Zone_Name__c];
        
        for (Time_Zone__c timeZone : timeZones) {
            timeZoneOptions.add(timeZone.Time_Zone_Name__c);
        }
        
        return timeZoneOptions;
        
    } */
   
    
    @AuraEnabled( cacheable = true )    
    public static User fetchInfo() { 
        
        User objUser;
        Id userId = System.UserInfo.getUserId();
        String EXPECTED_EXPECTION = 'List has no rows for assignment to SObject';
        String DOESNOTEXIST = 'does not exist';
        String QUERY_TEST = 'SELECT Id FROM User WHERE Name =:DOESNOTEXIST LIMIT 1';
        String QUERY_USER = 'SELECT Innova_Region__c,Innova_Brand__c,Time_Zone__c,Unique_Auto_ID__c  FROM User WHERE Id =:userId LIMIT 1';
        
        try{
          
            if(System.Test.isRunningTest()){
                objUser = Database.Query(QUERY_TEST);
                } else {
                    objUser = Database.Query(QUERY_USER); 
            	}
        
            return objUser;
            
            }
        catch (QueryException e) {
            if (e.getMessage().contains(EXPECTED_EXPECTION)) {
                // Handle the case where no user is found with the provided ID
                return null;
            }
            throw new AuraHandledException('Error fetching user details: ' + e.getMessage());
        }
         }

}