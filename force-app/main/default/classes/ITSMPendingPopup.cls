public class ITSMPendingPopup {
@AuraEnabled
    public static Boolean getCases(String cId) {
        Case getCaseRecord = [Select Id,IsClosedStatus__c From Case where Id= :cId];
        return getCaseRecord.IsClosedStatus__c;
    }
}