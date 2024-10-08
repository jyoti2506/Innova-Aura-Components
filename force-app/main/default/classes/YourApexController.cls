public with sharing class YourApexController {
   @AuraEnabled
    public static list<listViewWrapper> listValues(string objectInfo){

        list<listViewWrapper> oListViewWrapper = new list<listViewWrapper>();

        for(ListView lv : [SELECT id, Name, DeveloperName FROM ListView
                           WHERE sObjectType = : objectInfo ORDER By Name ASC]){ 
            listViewWrapper oWrapper = new listViewWrapper();
            oWrapper.label = lv.Name;
            oWrapper.developerName = lv.DeveloperName;
            oListViewWrapper.add(oWrapper);
        }
       return oListViewWrapper; 
    }

    /*wrapper class to store listView details*/ 
    public class listViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    }
}