@isTest
public class portalTaskController_TEST {
    
    public static testMethod void testGetTaskBannerData(){
        
        Innova_ITSC_Task__c t = new Innova_ITSC_Task__c();
        insert t;
        
        PortalTaskController.getTaskBannerData(t.Id);
        PortalTaskController.getTaskDetail(t.Id);
        PortalTaskController.getTask(t.Id);
    }

}