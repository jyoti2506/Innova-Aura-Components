@IsTest(SeeAllData=true)
public class UserUtilTest {
    
    public static testMethod void TEST_getContactIdByUserId(){  
        User jo = [Select Id from User Where LastName = 'utermehle' limit 1];
        UserUtil.getContactIdByUserId(jo.id);
    }
    
    //public static testMethod void TEST_getContactIdByAccountId(){
   //     Account a = [Select Id from Account Where LastName = 'Paul' limit 1];
    //    UserUtil.getContactIdByAccountId(a.Id);
    //}
    
    /*
     * u = new User(
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
*/
    
    /*
     * Account acc = new Account(
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
*/
    
    /*
     * Employee emp = new Employee(
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
*/

}