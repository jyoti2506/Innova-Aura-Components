public with sharing class PathControllerTask {
    
    @AuraEnabled(cacheable=true)
    public static String getTaskStatusPath(Id taskId) {
        
        List<String> statusPath = new List<String>();
        
        for (Innova_ITSC_Task__c t : [SELECT Innova_Status__c FROM Innova_ITSC_Task__c WHERE Id = :taskId ]) {
            statusPath.add(t.Innova_Status__c);                              
        }
           return String.join(statusPath, ' > ');
    }

}