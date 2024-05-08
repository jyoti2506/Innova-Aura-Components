@isTest
private class changeRequestControllerTest {

    // Utility method to create a ChangeRequest record for testing
    private static ChangeRequest createTestChangeRequest() {
        ChangeRequest cr = new ChangeRequest();
        //cr.ChangeRequestNumber = 'CHG-000000003';
        cr.Subject = 'Test Subject';
        cr.Status = 'Open';
        //cr.Created_By_Full_Name__c = 'Jyoti Zanjurne';
        cr.Description = 'Test Description';
        cr.Priority = 'High';
        cr.Category = 'Database';
        cr.Impact = 'High';
        cr.Implementation_Plan__c = 'Test Implementation Plan';
        cr.Test_Plan__c = 'Test Plan';
        cr.Roll_Back_Plan__c = 'Test Rollback Plan';
        insert cr;
        return cr;
    }
    
    // Test for getChangeRequestBannerData method
    @isTest static void testGetChangeRequestBannerData() {
        ChangeRequest cr = createTestChangeRequest();
        
        Test.startTest();
        String result = changeRequestController.getChangeRequestBannerData(cr.Id);
        Test.stopTest();
        
        //System.assert(result.contains(cr.ChangeRequestNumber), 'ChangeRequestNumber should be present in the result');
        System.assert(result.contains(cr.Subject), 'Subject should be present in the result');
        System.assert(result.contains(cr.Status), 'Status should be present in the result');
        //System.assert(result.contains(cr.Created_By_Full_Name__c), 'Created_By_Full_Name__c should be present in the result');
    } 

    // Test for getChangeRequestDetail method
    @isTest static void testGetChangeRequestDetail() {
        ChangeRequest cr = createTestChangeRequest();
        
        Test.startTest();
        String result = changeRequestController.getChangeRequestDetail(cr.Id);
        Test.stopTest();
        
        System.assert(result.contains(cr.Subject), 'Subject should be present in the result');
        System.assert(result.contains(cr.Description), 'Description should be present in the result');
        // Add assertions for other fields as well
    }

    // Test for getChangeRequest method
    @isTest static void testGetChangeRequest() {
        ChangeRequest cr = createTestChangeRequest();
        
        Test.startTest();
        ChangeRequest resultCr = changeRequestController.getChangeRequest(cr.Id);
        Test.stopTest();
        
        System.assertEquals(cr.Subject, resultCr.Subject, 'The subject of the returned ChangeRequest should match the test record');
    }
}