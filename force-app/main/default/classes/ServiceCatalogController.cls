public class ServiceCatalogController {
    
    @AuraEnabled
    public static List<ISC_Catalog_Item__c> getCatalogItems(){
        return [SELECT Title__c, Subtitle__c, Flow_API_Name__c, Icon__c, Order__c   from ISC_Catalog_Item__c order by Order__c];
    }

}