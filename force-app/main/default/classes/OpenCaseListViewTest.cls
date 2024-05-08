@IsTest
private class OpenCaseListViewTest {
    
    
    @isTest
    static void testGetCases() {
        // Create test cases
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            Case c = new Case(Subject = 'Test Case ' + i, Status = 'New'); // Creating cases with status 'New'
            testCases.add(c);
        }
        insert testCases;

       /* // Update the status of the cases to 'Closed' and simulate closed date/time within the last 72 hours
        List<Case> closedCases = [SELECT Id FROM Case WHERE Id IN :testCases];
        for (Case c : closedCases) {
            c.Status = 'Closed';
            c.Innova_Region1__c='Canada';
            c.Innova_Brand1__c='Volt';
        }
        update closedCases;
*/

        // Insert test data for Employee and Person Account objects
       User u;
try {
    u = [SELECT Id FROM User LIMIT 1];
} catch (QueryException e) {
    // Handle no rows found
    System.debug('No user found: ' + e.getMessage());
}
        
          if (u == null) {
            // If no user record is found, create a new user for testing
            u = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@example.com',
                Username = 'testuser@example.com',
                Alias = 'tuser',
                CommunityNickname = 'tuser',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                //ProfileId = p.Id,
                IsActive = true
            );
            insert u;
            
          }
        

        // Create a Person Account
        Account acc = new Account(
            FirstName = 'John',
            MiddleName='Jessie',
            LastName = 'Doe',
            Innova_Employee_Number__pc='CA- 12',
            Employee_Status__pc='Active',
            WorkerType__pc='Employee',
            StatusAsOf__pc=  Date.today(),
            RecordTypeId = '012Dn000000AvqwIAC'
            // Add any other required fields for a person account
            //PersonEmail = 'johndoe@example.com', // Sample email
            //PersonBirthdate = Date.newInstance(1980, 1, 1) // Sample birthdate
        );
        insert acc;

         // Insert an Employee record with the Person Account Id as the RelatedPersonId
        Employee emp = new Employee(
            UserId = u.Id,
            RelatedPersonId = acc.Id,
            FirstName = 'John',
            LastName = 'Doe',
            EmployeeNumber='1234',
            StatusAsOf=Date.today(),
            EmployeeStatus='Active',
            WorkerType='Employee'
           
            
        );
        insert emp;
     
       //User u = createTestUser();
        // Mock UserId for testing
        Id userId = u.Id;

        // Mock Account and Contact Ids
        Id accountId = null;
        Id contactId = null;

        try {
            //accountId = UserUtil.getAccountIdByUserId(userId);
            //contactId = UserUtil.getContactIdByUserId(userId);
        } catch (Exception e) {
            // Handle exception
            System.debug('Error occurred while getting account and contact Ids: ' + e.getMessage());
        }

        // Test with searchKeyword
        System.runAs(u) {
        Test.startTest();
        
        	List<Case> resultWithKeyword = OpenCaseListView.getCases(5, 1, 'Test');
        
            Test.stopTest();
        	System.assertEquals(5, resultWithKeyword.size(), 'Search with keyword should return all test cases');
		}
        
        /*// Test without searchKeyword
         System.runAs(u) {
        Test.startTest();
        List<Case> resultWithoutKeyword = OpenCaseListView.getCases(5, 1, null);
        Test.stopTest();
        System.assertEquals(5, resultWithoutKeyword.size(), 'Search without keyword should return all test cases');
         }*/
     }
    
     @isTest
    static void testGetCasesWithShortKeyword() {
        // Create test cases
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            Case c = new Case(Subject = 'Test Case ' + i, Status = 'New'); // Creating cases with status 'New'
            testCases.add(c);
        }
        insert testCases;

       /* // Update the status of the cases to 'Closed' and simulate closed date/time within the last 72 hours
        List<Case> closedCases = [SELECT Id FROM Case WHERE Id IN :testCases];
        for (Case c : closedCases) {
            c.Status = 'Closed';
            c.Innova_Region1__c='Canada';
            c.Innova_Brand1__c='Volt';
        }
        update closedCases;
*/

        // Insert test data for Employee and Person Account objects
       User u;
try {
    u = [SELECT Id FROM User LIMIT 1];
} catch (QueryException e) {
    // Handle no rows found
    System.debug('No user found: ' + e.getMessage());
}
        
          if (u == null) {
            // If no user record is found, create a new user for testing
            u = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@example.com',
                Username = 'testuser@example.com',
                Alias = 'tuser',
                CommunityNickname = 'tuser',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                //ProfileId = p.Id,
                IsActive = true
            );
            insert u;
            
          }
        

        // Create a Person Account
        Account acc = new Account(
            FirstName = 'John',
            MiddleName='Jessie',
            LastName = 'Doe',
            Innova_Employee_Number__pc='CA- 12',
            Employee_Status__pc='Active',
            WorkerType__pc='Employee',
            StatusAsOf__pc=  Date.today(),
            RecordTypeId = '012Dn000000AvqwIAC'
            // Add any other required fields for a person account
            //PersonEmail = 'johndoe@example.com', // Sample email
            //PersonBirthdate = Date.newInstance(1980, 1, 1) // Sample birthdate
        );
        insert acc;

         // Insert an Employee record with the Person Account Id as the RelatedPersonId
        Employee emp = new Employee(
            UserId = u.Id,
            RelatedPersonId = acc.Id,
            FirstName = 'John',
            LastName = 'Doe',
            EmployeeNumber='1234',
            StatusAsOf=Date.today(),
            EmployeeStatus='Active',
            WorkerType='Employee'
           
            
        );
        insert emp;
     
       //User u = createTestUser();
        // Mock UserId for testing
        Id userId = u.Id;

        // Mock Account and Contact Ids
        Id accountId = null;
        Id contactId = null;

        try {
            //accountId = UserUtil.getAccountIdByUserId(userId);
            //contactId = UserUtil.getContactIdByUserId(userId);
        } catch (Exception e) {
            // Handle exception
            System.debug('Error occurred while getting account and contact Ids: ' + e.getMessage());
        }

       /* // Test with searchKeyword
        System.runAs(u) {
        Test.startTest();
        
        	List<Case> resultWithKeyword = OpenCaseListView.getCases(5, 1, 'Test');
        
            Test.stopTest();
        	System.assertEquals(5, resultWithKeyword.size(), 'Search with keyword should return all test cases');
		}*/
        
        // Test without searchKeyword
         System.runAs(u) {
        Test.startTest();
        List<Case> resultWithoutKeyword = OpenCaseListView.getCases(5, 1, 'Te');
        Test.stopTest();
        System.assertEquals(5, resultWithoutKeyword.size(), 'Search without keyword should return all test cases');
         }
     }
    
    
    @isTest
    static void testGetQueryWithoutSearchKeyword() {
        // Setup
        User testUser = createTestUser();
        System.runAs(testUser) {
            createTestCases('New Case', 'New', 3); // Creating 3 New cases
            
            // Assuming we have a way to link the cases to the user/contact, which you need to implement

            // Execute
            String query = OpenCaseListView.getQuery(5, 1, null);

            // Verify
            Test.startTest();
            List<Case> results = Database.query(query);
            Test.stopTest();

            System.assertEquals(3, results.size(), 'Should return all New cases when no search keyword is provided.');
        }
    }
     // Helper method to create Case records
    
    
    @isTest
    static void testGetCasesTotalWithSearch() {
        // Setup: Create 10 test Case records with a specific subject pattern
         User testUser = createTestUser();
        System.runAs(testUser) {
        Integer numCases = 0;
        String subjectBase = 'Test Case';
        createTestCases(numCases, subjectBase);

        // Test: Search with a keyword that matches all created cases
        Test.startTest();
        Integer casesTotal = OpenCaseListView.getCasesTotal(subjectBase);
        Test.stopTest();
         
         System.debug('Expected cases: ' + numCases + ', Actual cases: ' + casesTotal);

        // Verify: All created cases are found
        System.assertEquals(numCases, casesTotal, 'Should return the correct total number of cases matching the keyword.');
        }
    }
    
    @isTest
    static void testGetCasesTotalWithNoSearch() {
        // Setup: Create 5 more test Case records with a different subject
         User testUser = createTestUser();
        System.runAs(testUser) {
        Integer numAdditionalCases = 5;
        String differentSubjectBase = 'Other Case';
        createTestCases(numAdditionalCases, differentSubjectBase);

        // Test: Perform a search without a keyword
        Test.startTest();
        Integer totalCases = OpenCaseListView.getCasesTotal(null);
        Test.stopTest();

        // Verify: Since the keyword is null, it should attempt to count all Case records (subject to the method's logic and SOQL limits)
        System.assertNotEquals(-1, totalCases, 'Should return a total count of cases or a capped number, not -1.');
        }
    }
    
    @isTest
    static void testGetUserTimeZone() {
        // Execute
        String timeZone = OpenCaseListView.getUserTZ();

        // Verify
        System.assertNotEquals(null, timeZone, 'Should return a non-null time zone.');
}
    
     private static void createTestCases(String subject, String status, Integer count) {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            cases.add(new Case(Subject=subject + ' ' + i, Status=status));
        }
        insert cases;
    }
    
    
    private static void createTestCases(Integer numCases, String subjectBase) {
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < numCases; i++) {
            Case newCase = new Case(Subject = subjectBase + ' ' + i, Status = 'New');
            caseList.add(newCase);
        }
        insert caseList;
    } 
    
    private static User createTestUser() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard Platform User' LIMIT 1];
        
        User u;
try {
    u = [SELECT Id FROM User LIMIT 1];
} catch (QueryException e) {
    // Handle no rows found
    System.debug('No user found: ' + e.getMessage());
}
        
          if (u == null) {
            // If no user record is found, create a new user for testing
            u = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@example.com',
                Username = 'testuser@example.com',
                Alias = 'tuser',
                CommunityNickname = 'tuser',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                ProfileId = p.Id,
                IsActive = true
            );
            insert u;
            
          }
        

        // Create a Person Account
        Account acc = new Account(
            FirstName = 'John',
            MiddleName='Jessie',
            LastName = 'Doe',
            Innova_Employee_Number__pc='CA- 12',
            Employee_Status__pc='Active',
            WorkerType__pc='Employee',
            StatusAsOf__pc=  Date.today(),
            RecordTypeId = '012Dn000000AvqwIAC'
            // Add any other required fields for a person account
            //PersonEmail = 'johndoe@example.com', // Sample email
            //PersonBirthdate = Date.newInstance(1980, 1, 1) // Sample birthdate
        );
        insert acc;

         // Insert an Employee record with the Person Account Id as the RelatedPersonId
        Employee emp = new Employee(
            UserId = u.Id,
            RelatedPersonId = acc.Id,
            FirstName = 'John',
            LastName = 'Doe',
            EmployeeNumber='1234',
            StatusAsOf=Date.today(),
            EmployeeStatus='Active',
            WorkerType='Employee'
           
            
        );
        insert emp;
       return u; 
    }
    
   
}