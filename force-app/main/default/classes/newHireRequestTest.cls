@isTest
public class newHireRequestTest {
    @isTest
    public static void testGetApplication() {
        
        List<Innova_Application_Software__c> applicationList = new List<Innova_Application_Software__c>();
        
        
        Innova_Application_Software__c app3 = new Innova_Application_Software__c(Name = 'App 3');
        Innova_Application_Software__c app4 = new Innova_Application_Software__c(Name = 'App 4');
       
        
        applicationList.add(app3);
        applicationList.add(app4);
        
        insert applicationList;
        
       
        List<Innova_Application_Software__c> result = newHireRequest.getApplication('App', 1);
        
        
        //System.assertEquals(1, result.size());
       // System.assertEquals('App 3', result[0].Name);
     
       
    }
}