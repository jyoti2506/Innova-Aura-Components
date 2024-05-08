@isTest(SeeAllData=true)
private class UserEmailFromTemplateTest{
    
    @isTest static void TestAgent() {
        
        UserEmailFromTemplate.ParameterWrapper[] inputs = new List<UserEmailFromTemplate.ParameterWrapper>();
        UserEmailFromTemplate.ParameterWrapper input = new UserEmailFromTemplate.ParameterWrapper();
        
        user[] users = new list<user>();
        user testuser = [select id from user where id = '005Dn000007LOYG'];
        users.add(testuser);
        
        case[] testCase = [select Id,ContactId,CaseNumber from case order by casenumber desc limit 1];
        
        if (testCase.size() > 0 ) {
            input.recordId = testCase.get(0).id;
            input.templateName = 'Innova - Email to Queue - Case Created';
            input.targetUsers = users;
            input.orgWide = 'servicecloudsupport@innovasolutions.com';
            inputs.add (input);
            
            UserEmailFromTemplate.RenderUserEmailWithObject(inputs) ;
		}
    }
    
    @isTest static void TestAgent_Task() {
        
        UserEmailFromTemplate.ParameterWrapper[] inputs = new List<UserEmailFromTemplate.ParameterWrapper>();
        UserEmailFromTemplate.ParameterWrapper input = new UserEmailFromTemplate.ParameterWrapper();
        
        user[] users = new list<user>();
        user testuser = [select id from user where id = '005Dn000007LOYG'];
        users.add(testuser);
        
        Innova_ITSC_Task__c[] testTask = [select Id from Innova_ITSC_Task__c order by Name desc limit 1];
        
        if (testTask.size() > 0 ) {
            input.recordId = testTask.get(0).id;
            input.templateName = 'Innova - Email to Queue - Case Created';
            input.targetUsers = users;
            input.orgWide = 'servicecloudsupport@innovasolutions.com';
            inputs.add (input);
            
            UserEmailFromTemplate.RenderUserEmailWithObject(inputs) ;
		}
    }
    
    @isTest static void TestAgent_Change() {
        
        UserEmailFromTemplate.ParameterWrapper[] inputs = new List<UserEmailFromTemplate.ParameterWrapper>();
        UserEmailFromTemplate.ParameterWrapper input = new UserEmailFromTemplate.ParameterWrapper();
        
        user[] users = new list<user>();
        user testuser = [select id from user where id = '005Dn000007LOYG'];
        users.add(testuser);
        
        ChangeRequest[] cr = [select Id from ChangeRequest order by ChangeRequestNumber desc limit 1];
        
        if (cr.size() > 0 ) {
            input.recordId = cr.get(0).id;
            input.templateName = 'Innova - Email to Queue - Case Created';
            input.targetUsers = users;
            input.orgWide = 'servicecloudsupport@innovasolutions.com';
            inputs.add (input);
            
            UserEmailFromTemplate.RenderUserEmailWithObject(inputs) ;
		}
    }
    
    
}