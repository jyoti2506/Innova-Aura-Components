@isTest
private class CaseCompactControllerTest {
    
    @isTest static void testGetCaseRecord() {
        Case testCase = new Case(
            RecordTypeId = '012Dn000000AvrlIAC',
            Subject = 'Test Subject'
            // Set other required fields
        );
        
        try {
            insert testCase;
            
            String recordTypeId = CaseCompactController.getCaseRecord(testCase.Id);
            
            System.assertEquals(testCase.RecordTypeId, recordTypeId);
        } catch(Exception e) {
            System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    
   @isTest static void testGetJSONFieldSet() {
        String sObjectName = 'Case';
        String sFieldSetName = 'Case_Banner';

        try {
            Test.startTest();
            String result = CaseCompactController.getJSONFieldSet(sObjectName, sFieldSetName);
            Test.stopTest();

            System.assertNotEquals(null, result, 'Expected a non-null result');
            // Additional assertion to validate JSON format (Example)
            System.assert(result.startsWith('{'), 'Expected result to start with "{"');
        } catch(Exception e) {
            System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    
    @isTest static void testGetFieldSet() {
        String sObjectName = 'Case';
        String fieldSetName = 'Case_Banner';
        
        try {
            Test.startTest();
            String result = CaseCompactController.getFieldSet(sObjectName, fieldSetName);
            Test.stopTest();
            
            System.assertNotEquals(null, result, 'Expected a non-null result');
        } catch(Exception e) {
            System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    
    @isTest static void testGetHelpTextForField() {
        String sObjectName = 'Case';
        String sField = 'Case_Banner';
        
        try {
            Test.startTest();
            String helpText = CaseCompactController.gethelpText(sObjectName, sField);
            Test.stopTest();
            
            System.assertNotEquals(null, helpText, 'Expected a non-null result');
        } catch(Exception e) {
            System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    
    @isTest static void testGetCase() {
        Case testCase = new Case(
            Subject = 'Test Subject',
            Description = 'Test Description',
            Status = 'New'
            // Set other required fields
        );
        
        try {
            insert testCase;
            
            List<String> fieldList = new List<String>{'Subject', 'Description', 'Status'};
            List<String> fieldLabel = new List<String>{'Subject', 'Description', 'Status'};
            
            Test.startTest();
            List<CaseCompactController.wrapperC> result = CaseCompactController.getCase(testCase.Id, fieldList, fieldLabel);
            Test.stopTest();
            
            System.assertNotEquals(null, result, 'Expected a non-null result');
            System.assertEquals(3, result.size(), 'Expected a list size of 3');
        } catch(Exception e) {
            System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    
    @isTest static void testGetCaseRecordWithInvalidId() {
        try {
            String recordTypeId = CaseCompactController.getCaseRecord('invalidId');
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.QueryException', e.getTypeName(), 'Expected a QueryException');
        }
    }
    
    @isTest static void testGetJSONFieldSetWithInvalidName() {
        try {
            String result = CaseCompactController.getJSONFieldSet('InvalidObject', 'TestFieldSet');
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.QueryException', e.getTypeName(), 'Expected a QueryException');
        }
    }
    
    @isTest static void testGetFieldSetWithInvalidName() {
        try {
            String result = CaseCompactController.getFieldSet('InvalidObject', 'TestFieldSet');
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.QueryException', e.getTypeName(), 'Expected a QueryException');
        }
    }
    
    @isTest static void testGetHelpTextForFieldWithInvalidField() {
        try {
            String helpText = CaseCompactController.gethelpText('Case', 'InvalidField');
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.QueryException', e.getTypeName(), 'Expected a QueryException');
        }
    }
    
    @isTest static void testGetCaseWithInvalidId() {
        try {
            List<String> fieldList = new List<String>{'Subject', 'Description', 'Status'};
            List<String> fieldLabel = new List<String>{'Subject', 'Description', 'Status'};
            
            List<CaseCompactController.wrapperC> result = CaseCompactController.getCase('invalidId', fieldList, fieldLabel);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.QueryException', e.getTypeName(), 'Expected a QueryException');
        }
    }
    
    @isTest static void testGetCaseRecordWithNullId() {
        try {
            String recordTypeId = CaseCompactController.getCaseRecord(null);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.NullPointerException', e.getTypeName(), 'Expected a NullPointerException');
        }
    }
    
    @isTest static void testGetJSONFieldSetWithNullValues() {
        try {
            String result = CaseCompactController.getJSONFieldSet(null, null);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.NullPointerException', e.getTypeName(), 'Expected a NullPointerException');
        }
    }
    
    @isTest static void testGetFieldSetWithNullValues() {
        try {
            String result = CaseCompactController.getFieldSet(null, null);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.NullPointerException', e.getTypeName(), 'Expected a NullPointerException');
        }
    }
    
    @isTest static void testGetHelpTextForFieldWithNullValues() {
        try {
            String helpText = CaseCompactController.gethelpText(null, null);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.NullPointerException', e.getTypeName(), 'Expected a NullPointerException');
        }
    }
    
    @isTest static void testGetCaseWithNullValues() {
        try {
            List<CaseCompactController.wrapperC> result = CaseCompactController.getCase(null, null, null);
            
            System.assert(false, 'Expected an exception but none occurred');
        } catch(Exception e) {
            System.assertEquals('System.NullPointerException', e.getTypeName(), 'Expected a NullPointerException');
        }
    }
}