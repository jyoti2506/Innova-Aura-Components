@isTest
public class ServiceCatalogHeaderControllerTest {

    // Utility method to create a test record
    static ISC_Catalog_Item__c createTestCatalogItem(String flowApiName, String title) {
        ISC_Catalog_Item__c item = new ISC_Catalog_Item__c();
        item.Flow_API_Name__c = flowApiName;
        item.Title__c = title;
        insert item;
        return item;
    }

    // Test method to verify retrieval of title
    @isTest static void testGetTitleByFlowApiNameWithResult() {
        // Setup: Create a test catalog item
        String testFlowApiName = 'TestFlowApiName';
        String expectedTitle = 'Test Title';
        createTestCatalogItem(testFlowApiName, expectedTitle);

        // Test: Invoke the method
        Test.startTest();
        String result = ServiceCatalogHeaderController.getTitleByFlowApiName(testFlowApiName);
        Test.stopTest();

        // Verify: The correct title is returned
        System.assertEquals(expectedTitle, result, 'The title should match the expected value.');
    }

    // Test method to verify behavior when no matching record is found
   /* @isTest static void testGetTitleByFlowApiNameNoResult() {
        // Setup: Ensure no catalog item matches the test API name
        String testFlowApiName = '';

        // Test: Invoke the method
        Test.startTest();
        String result = ServiceCatalogHeaderController.getTitleByFlowApiName(testFlowApiName);
        Test.stopTest();

        // Verify: An empty string is returned
        System.assertEquals('', result, 'The result should be an empty string when no record is found.');
    }*/
}