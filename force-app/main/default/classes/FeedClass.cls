public class FeedClass {
  @AuraEnabled
    public static List<FeedItem> getCommentsAndEmails() {
        List<FeedItem> commentsAndEmails = new List<FeedItem>();
        
       
        commentsAndEmails = [SELECT Id, Body, CreatedDate, ParentId, Type
                             FROM FeedItem
                             WHERE Type IN ('TextPost', 'EmailMessage')
                             ORDER BY CreatedDate DESC
                            ]; 
        
        return commentsAndEmails;
    }
}