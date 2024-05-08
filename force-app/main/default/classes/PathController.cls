public with sharing class PathController {
  @AuraEnabled(cacheable=true)
    public static String getChangeRequestStatusPath(Id changeRequestId) {
        List<String> statusPath = new List<String>();
        for (ChangeRequest cr : [SELECT Status 
                                     FROM ChangeRequest 
                                     WHERE Id = :changeRequestId ]) {
            statusPath.add(cr.Status);
                                        
        }
           return String.join(statusPath, ' > ');
    }
}