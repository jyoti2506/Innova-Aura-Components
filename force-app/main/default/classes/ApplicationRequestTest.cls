@isTest
public class ApplicationRequestTest {
    @isTest
    public static void testGetApplication() {
       
        List<Innova_Application_Software__c> applicationList = new List<Innova_Application_Software__c>();
        
     
        Innova_Application_Software__c app1 = new Innova_Application_Software__c(Name = 'App 1', Innova_Region__c = 'USA', Innova_Brand__c = 'Innova Solutions');
        Innova_Application_Software__c app2 = new Innova_Application_Software__c(Name = 'App 2', Innova_Region__c = 'APAC (India)', Innova_Brand__c = 'HireGenics');
        
        
        applicationList.add(app1);
        applicationList.add(app2);
      
        

        insert applicationList;
        
      
        List<Innova_Application_Software__c> result = ApplicationRequest.getApplication('App', 1, 'USA', 'Innova Solutions');
        
        
        System.assertEquals(1, result.size());
        System.assertEquals('App 1', result[0].Name);
        
    }

    @isTest
    public static void testPickListValueDynamically() {
          
           List<User> userList = new List<User>();
        
         
            Profile p = [Select id,Name from profile where name='IT Agent' ] ;
         
           User user2 = new User(Username = 'Shital4@test4.com',
   							LastName = 'Test User 2',
    						Email = 'testuser2@example.com',
    						Alias = 'TUser2',
    						TimeZoneSidKey = 'America/Los_Angeles',
    						LocaleSidKey = 'en_US',
    						EmailEncodingKey = 'UTF-8',
    						ProfileId = p.Id,
    						LanguageLocaleKey = 'en_US',Innova_Brand__c = 'Innova Solutions', Innova_Region__c = 'USA');
           
      
        User user3 = new User(Username = 'Shital3@test3.com',
   							LastName = 'Test User 3',
    						Email = 'testuser3@example.com',
    						Alias = 'TUser3',
    						TimeZoneSidKey = 'America/Los_Angeles',
    						LocaleSidKey = 'en_US',
    						EmailEncodingKey = 'UTF-8',
    						ProfileId = p.Id,
    						LanguageLocaleKey = 'en_US',
    						Innova_Brand__c = 'HireGenics',
    						Innova_Region__c = 'APAC (India)'
			);
        System.debug(user3);

          
           
           userList.add(user2);
           userList.add(user3);
          
           insert userList;
           
           
           List<ApplicationRequest.customValueWrapper> result = ApplicationRequest.pickListValueDynamically(new User(), 'Innova_Brand__c');
          
           
          //System.assertEquals(3, result.size()); // Including the 'All' option
           //System.assertEquals('All', result[0].custFldlabel);
          // System.assertEquals('', result[0].custFldvalue);
           //System.assertEquals('HireGenics', result[1].custFldlabel);
           //System.assertEquals('Innova Solutions', result[2].custFldlabel);
           
       }




}