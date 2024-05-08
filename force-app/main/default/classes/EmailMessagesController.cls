public class EmailMessagesController {
    @AuraEnabled
    public static List<EmailMessage> getEmailMessages(String caseId) {
        return [SELECT Id, Subject, TextBody FROM EmailMessage WHERE ParentId = :caseId];
    }
}