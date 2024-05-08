@isTest
public class FeedItemTest {

    @isTest static void TestAgent() {
        
        Case c = new Case();
        insert c;
        
        FeedItem f = new FeedItem();
        f.Body = 'test body';
        f.ParentId = c.Id;
        insert f;
        
        
        c = [Select comments, Innova_End_User_Comment__c from Case Where Id = :c.Id];
        
        System.debug(c);
        
    }
}