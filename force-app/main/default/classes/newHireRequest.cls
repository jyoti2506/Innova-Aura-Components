public class newHireRequest {
    //@AuraEnabled is annotation enables LWC to access below apex method
    //(cacheable=true) is for caching the data on client side storage without waiting for server trips. Which imporves the performance
    @AuraEnabled(cacheable=true)
     public static List<Innova_Application_Software__c> getApplication(String searchKey,Integer pageNumber) {
      String key = '%' + searchKey + '%'; 
      pageNumber= ((pageNumber-1)*15);
      
     List<Innova_Application_Software__c> SearchApplicationList= [select Id,Name,Innova_Add__c, Innova_Edit__c, Innova_Delete__c, Innova_Requires_IT_Approval__c, Innova_Description_of_the_Request__c,Innova_Access_Level__c,Innova_Foundational_access__c  from Innova_Application_Software__c WHERE Name LIKE : key Order by Name Asc OFFSET :pageNumber ];
     if(SearchApplicationList.size()>0){
      return SearchApplicationList;
    
  
     }
     return null;
   }
  }