public with sharing class ChangeStatusController {
    @AuraEnabled(cacheable=true)
    public static String getCurrentStatus(Id recordId) {
        ChangeRequest changeRecord = [SELECT Status FROM ChangeRequest WHERE Id = :recordId LIMIT 1];
        return changeRecord.Status;
    }
    
}