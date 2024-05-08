public class TestDataFactory {

    public static User createUser() {
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'Seemashelke677@gmail.com',
            Username = 'Seemash677@gmail.com',
            Alias = 'TUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = UserInfo.getProfileId()
        );
        insert testUser;
        return testUser;
    }

   public static Case createCase() {
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New'
        );
        insert testCase;
        return testCase;
    }
    
    public static FeedItem createFeedItem(Case testCase,string comment, String itemType, String visibility) {
        
        FeedItem testFeedItem = new FeedItem(
            ParentId = testCase.Id,
            Body = comment,
            Type = itemType,
            Visibility = Visibility
        );
        insert testFeedItem;
        //  TestDataFactory.createFeedComment(testFeedItem.Id);
        return testFeedItem;
      
    }
    
  

    public static EmailMessage createEmailMessage(Id CaseId ) {
        EmailMessage testEmailMessage = new EmailMessage(
            Subject = 'Test Email',
            TextBody = 'Test Email Body',
            FromAddress = 'Seemashelke677@gmail.com',
            Incoming = true,
            ParentId=CaseId
        );
        insert testEmailMessage;
        
        //specifically added a query to ensure CreatedDate is being retreived
        EmailMessage e = [Select Subject, TextBody, FromAddress, Incoming, HtmlBody, ParentId, CreatedDate from EmailMessage Where Id = :testEmailMessage.Id limit 1];
        return e;
    }

public static FeedComment createFeedComment(FeedItem feedItem) {
    FeedComment testFeedComment = new FeedComment(
        FeedItemId = feedItem.Id,
        CommentBody = 'Test Comment',
        CreatedDate = DateTime.now()
    );
    insert testFeedComment;
    return testFeedComment;
}
}