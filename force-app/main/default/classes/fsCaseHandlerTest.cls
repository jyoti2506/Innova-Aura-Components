@isTest
private class fsCaseHandlerTest {

    @isTest static void testGetCaseRecord() {
        // Create a test Case record
        Case testCase = new Case(
            RecordTypeId = '012Dn000000AvrlIAC',
            Description = 'Description'
        );
        insert testCase;

        // Call the getCaseRecord method
        String result = fsCaseHandler.getCaseRecord(testCase.Id);

        // Verify the result
        System.assertEquals('012Dn000000AvrlIAC', result);
    }

    @isTest static void testGetJSONFieldSet() {
        // Call the getJSONFieldSet method
        String result = fsCaseHandler.getJSONFieldSet('Case', 'Case_Banner');

        // Verify the result
        System.assertNotEquals(null, result);
    }

    @isTest static void testGetFieldSet() {
        // Create a test Case record
        Case testCase = new Case();
        insert testCase;

        // Call the getFieldSet method
        String result = fsCaseHandler.getFieldSet('Case', 'Case_Banner');

        // Verify the result
        System.assertNotEquals(null, result);
    }

    @isTest static void testGetHelpText() {
        // Create a test Case record
        Case testCase = new Case();
        insert testCase;

        // Call the gethelpText method
        String result = fsCaseHandler.gethelpText('Case', 'Service');

        // Verify the result
        System.assertNotEquals(null, result);
    }

    @isTest static void testGetCase() {
        // Create a test Case record
        Case testCase = new Case(
            Description = 'Description',
            Status = 'New'
        );
        insert testCase;

        // Call the getCase method
        List<fsCaseHandler.wrapperC> result = fsCaseHandler.getCase(testCase.Id, new List<String>{'Description', 'Status'}, new List<String>{'Label1', 'Label2'});

        // Verify the result
       System.assertEquals(2, result.size());
        System.assertEquals('Label1', result[0].label);
        System.assertEquals('Description', result[0].value);
        System.assertEquals('Label2', result[1].label);
        System.assertEquals('New', result[1].value);
    }
}