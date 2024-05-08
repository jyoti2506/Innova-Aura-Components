public class massage {
  @AuraEnabled
    public static List<FeedComment> getCommentsByEmailMessageId(String emailMessageId) {
        return [SELECT Id, CreatedDate, ParentId, CommentBody, FeedItemId, CommentType 
                FROM FeedComment 
                WHERE ParentId = :emailMessageId];
    }
}