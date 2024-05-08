public with sharing class ServiceCatalogHeaderController {
    
     @AuraEnabled(cacheable=true)
    public static String getTitleByFlowApiName(String flowApiName) {
        // Query to get the title based on flowapiname
        ISC_Catalog_Item__c catalogRecord = [
            SELECT Title__c
            FROM ISC_Catalog_Item__c
            WHERE Flow_API_Name__c = :flowApiName
            LIMIT 1
        ];
        // Return the title if the record is found, otherwise return an empty string
        return (catalogRecord != null) ? catalogRecord.Title__c : '';
       
    }

}