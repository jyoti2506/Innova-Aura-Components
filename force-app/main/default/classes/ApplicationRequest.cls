public class ApplicationRequest {
  //@AuraEnabled is annotation enables LWC to access below apex method
  //(cacheable=true) is for caching the data on client side storage without waiting for server trips. Which imporves the performance
  @AuraEnabled(cacheable=true)
   public static List<Innova_Application_Software__c> getApplication(String searchKey,Integer pageNumber,String region,String brand) {
    String key = '%' + searchKey + '%'; 
    pageNumber= ((pageNumber-1)*15);
    List<User> currentUser =[Select Innova_Brand__c,Innova_Region__c FROM User WHERE Id= :UserInfo.getUserId()];
   List<Innova_Application_Software__c> SearchApplicationList= [select Id,Name,Innova_Add__c, Innova_Edit__c, Innova_Delete__c, Innova_Requires_IT_Approval__c, 
   Innova_Description_of_the_Request__c,Innova_Access_Level__c,Innova_Foundational_access__c  from Innova_Application_Software__c WHERE Name LIKE : key 
   
   AND Innova_Region__c = :region AND Innova_Brand__c = :brand
   Order by Name Asc OFFSET :pageNumber ];
   if(SearchApplicationList.size()>0){
    return SearchApplicationList;
  

   }
   return null;
 }

 @AuraEnabled(cacheable=true)
 public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) {

  Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();
  
  map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();
  
  list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
  
  list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();


  customValueWrapper blankOptionValueWrapper = new customValueWrapper();
  
  blankOptionValueWrapper.custFldlabel = '--None--';
  
  blankOptionValueWrapper.custFldvalue = '';
  
  customObjWrapper.add(blankOptionValueWrapper);


  
  for (Schema.PicklistEntry myCustPick: custPickValues) {
  
  customValueWrapper selectOptionValueWrapper = new customValueWrapper();
  
  selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
  
  selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
  
  customObjWrapper.add(selectOptionValueWrapper);
  
  }
  
  return customObjWrapper;
  
  }
  
  // wrapper class
  
  public with sharing class customValueWrapper {
  
  @auraEnabled public string custFldlabel {get;set;}
  
@auraEnabled public string custFldvalue {get;set;}
  
  }
  
  }