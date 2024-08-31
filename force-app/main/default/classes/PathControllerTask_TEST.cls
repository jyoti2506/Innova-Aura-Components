@isTest
public class PathControllerTask_TEST {
    
    public static testMethod void testGetTaskStatusPath(){
        
        Innova_ITSC_Task__c t = new Innova_ITSC_Task__c();
        
        PathControllerTask.getTaskStatusPath(t.Id);
        
    }

}