@isTest
public class OpenCaseListViewTest2 {

    @testSetup static void methodName() {
        
        TestDataFactory.createCase();
        
        User u = TestDataFactory.createUser();
        Account a = TestDataFactory.createAccount();
        Employee e = TestDataFactory.createEmployee(u.Id,a.Id);

	}
    
    @isTest
    static void testGetCases(){
        
        User u = [Select Id from User Where Email = 'fakeemail@thisifake.com' limit 1];
        
        System.runAs(u){
        	OpenCaseListView.getCases(1, 1, null);    
        }
        
    }
    
    @isTest
    static void testGetCasesTotal(){
        
        User u = [Select Id from User Where Email = 'fakeemail@thisifake.com' limit 1];
        
        System.runAs(u){
        	OpenCaseListView.getCasesTotal('nothing');    
        }
    }
    
    @isTest
    static void testGetUserTZ(){
        
        User u = [Select Id from User Where Email = 'fakeemail@thisifake.com' limit 1];
        
        System.runAs(u){
        	OpenCaseListView.getUserTZ();    
        }
    }
}