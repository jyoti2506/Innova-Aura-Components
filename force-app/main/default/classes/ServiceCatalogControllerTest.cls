@isTest
public class ServiceCatalogControllerTest {

    // Utility method to create test data
    private static List<ISC_Catalog_Item__c> createTestCatalogItems(Integer count) {
        List<ISC_Catalog_Item__c> items = new List<ISC_Catalog_Item__c>();
        for (Integer i = 0; i < count; i++) {
            items.add(new ISC_Catalog_Item__c(
                Title__c = 'Test Title ' + i,
                Subtitle__c = 'Test Subtitle ' + i,
                Flow_API_Name__c = 'FlowName' + i,
                Icon__c = 'icon' + i,
                Order__c = i
            ));
        }
        return items;
    }

    // Test method to verify that catalog items are returned in the correct order
    @isTest
    static void testGetCatalogItems() {
        // Insert test data
        List<ISC_Catalog_Item__c> testItems = createTestCatalogItems(5);
        insert testItems;

        // Perform test
        Test.startTest();
        List<ISC_Catalog_Item__c> returnedItems = ServiceCatalogController.getCatalogItems();
        Test.stopTest();

        // Assertions to ensure correctness of the output
        System.assertEquals(5, returnedItems.size(), 'Should return exactly 5 catalog items.');
        for (Integer i = 0; i < returnedItems.size(); i++) {
            ISC_Catalog_Item__c item = returnedItems[i];
            System.assertEquals('Test Title ' + i, item.Title__c, 'Title should match for item ' + i);
            System.assertEquals('Test Subtitle ' + i, item.Subtitle__c, 'Subtitle should match for item ' + i);
            System.assertEquals('FlowName' + i, item.Flow_API_Name__c, 'Flow API Name should match for item ' + i);
            System.assertEquals('icon' + i, item.Icon__c, 'Icon should match for item ' + i);
            System.assertEquals(i, item.Order__c, 'Order should match for item ' + i);
        }
    }

}