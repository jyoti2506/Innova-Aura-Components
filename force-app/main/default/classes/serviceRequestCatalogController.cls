public class serviceRequestCatalogController {
    
    private static final String QUERY_ACTIVE_CATEGORIES = 'SELECT MasterLabel FROM SvcCatalogCategory WHERE IsActive = true ORDER BY SortOrder';
    private static final String QUERY_ACTIVE_ITEMS = 'SELECT Id, SvcCatalogCategory.MasterLabel, SvcCatalogItemDef.MasterLabel, SvcCatalogItemDef.Description from SvcCatalogCategoryItem where SvcCatalogCategory.IsActive = true';
    
    @AuraEnabled
    public static List<String> getActiveCategories(){
        
        List<String> activeCategoryList = new List<String>();
        
        for(SvcCatalogCategory cat: Database.query(QUERY_ACTIVE_CATEGORIES)){
            activeCategoryList.add(cat.MasterLabel);
        }
        
        return activeCategoryList;
    }
    
    @AuraEnabled
    public static List<ServiceRequestItem> getRequestsByCategory(String categoryName){
        System.debug('getRequestsByCategory param: ' + categoryName);
        
        List<ServiceRequestItem> itemList = new List<ServiceRequestItem>();
        
        for(SvcCatalogCategoryItem item: Database.query(QUERY_ACTIVE_ITEMS)){
            String itemCategory = item.SvcCatalogCategory.MasterLabel;
            
            if( categoryName != null ){
            	if(itemCategory == categoryName){
                	ServiceRequestItem srItem = new ServiceRequestItem(item);
                	itemList.add(srItem);
            	}	    
            } else {
                ServiceRequestItem srItem = new ServiceRequestItem(item);
                	itemList.add(srItem);
            }
 
        }
        
        System.debug('returning ' + itemList.size() + ' items');
        return itemList;
    }
    
    public class ServiceRequestItem {
        
        @AuraEnabled public String Id;
        @AuraEnabled public String CategoryName;
        @AuraEnabled public String ServiceRequestItemName;
        @AuraEnabled public String ServiceRequestItemDesc;
        
        public ServiceRequestItem(SvcCatalogCategoryItem item) {
            this.Id = item.Id;
            this.CategoryName = item.SvcCatalogCategory.MasterLabel;
            this.ServiceRequestItemName = item.SvcCatalogItemDef.MasterLabel;
            this.ServiceRequestItemDesc = item.SvcCatalogItemDef.Description.stripHtmlTags();
        }
    }

}