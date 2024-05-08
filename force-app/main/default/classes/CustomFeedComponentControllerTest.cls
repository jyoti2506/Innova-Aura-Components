@isTest
public class CustomFeedComponentControllerTest {
  
    @isTest static void testGetCaseCommentswithEmail() {
        
        Case testCase = TestDataFactory.createCase();
        
        FeedItem testFeedItemTextPost = TestDataFactory.createFeedItem(testCase, 'TextPost', 'TextPost', 'AllUsers');
        FeedItem testFeedItemEmailMsg = TestDataFactory.createFeedItem(testCase, 'EmailMessageEvent', 'EmailMessageEvent', 'AllUsers');
        
        EmailMessage testEmailMessage = TestDataFactory.createEmailMessage(testCase.Id); //does not go into feed item
        
        //System.debug('testFeedItem: ' + testFeedItem);
        //System.debug('testEmailMessage: ' + testEmailMessage);
        
        Test.startTest();
        List<CustomFeedComponentController.FeedItemWrapper> comments = 
            CustomFeedComponentController.getCaseCommentswithEmail(testCase.Id);
        Test.stopTest();
        
        System.assertEquals(2, comments.size());
        //System.assertEquals(testFeedItemTextPost.Id, comments[0].Id); //does the order matter?
        //System.assertEquals(testEmailMessage.Id, comments[1].Id);
    } 
    
    @isTest static void testEmailMessageWrapper(){
        
        Test.startTest();
        Case testCase = TestDataFactory.createCase();
        EmailMessage testEmailMessage = TestDataFactory.createEmailMessage(testCase.Id);
        System.debug('testEmailMessage-: ' + testEmailMessage );
        Test.stopTest();
        
        CustomFeedComponentController.EmailMessageWrapper w = new CustomFeedComponentController.EmailMessageWrapper(testEmailMessage);
        
        
    }
    
    @isTest static void testFeedCommentWrapper(){
        
        Test.startTest();
        Case testCase = TestDataFactory.createCase();
        FeedItem testFeedItem = TestDataFactory.createFeedItem(testCase, 'TextPost', 'TextPost', 'AllUsers');
        FeedComment testFeedComment = TestDataFactory.createFeedComment(testFeedItem);
        Test.stopTest();
        
        CustomFeedComponentController.feedCommentWrapper w = new CustomFeedComponentController.feedCommentWrapper(testFeedComment);
    }
    
    @isTest static void testHTMLStrip(){
        CustomFeedComponentController.stripHtmlTags('test');
    }
    
    @isTest static void testCreateChatterPost(){
        
        Test.startTest();
        Case testCase = TestDataFactory.createCase();
        CustomFeedComponentController.createChatterPost(testCase.Id, 'test post');
        Test.stopTest();
        
        
    }
    
    @isTest static void testCreateFeedComment(){
        
        Test.startTest();
        
        Case testCase = TestDataFactory.createCase();
        FeedItem testFeedItem = TestDataFactory.createFeedItem(testCase, 'TextPost', 'TextPost', 'AllUsers');
        //FeedComment testFeedComment = TestDataFactory.createFeedComment(testFeedItem);
        CustomFeedComponentController.createFeedCommentMethod(testFeedItem.Id, 'test post');
        Test.stopTest();
        
        
    }
    
    @isTest static void testGetCaseComments(){
        Case testCase = TestDataFactory.createCase();
        CustomFeedComponentController.getCaseComments(testCase.Id);
    }
    
    @isTest static void testGetEmailMessageById(){
        Case testCase = TestDataFactory.createCase();
        EmailMessage testEmailMessage = TestDataFactory.createEmailMessage(testCase.Id);
        
        CustomFeedComponentController.getEmailMessageById(testEmailMessage.Id);
        
    }
    
    @isTest static void testCheckCaseStatus(){
        
        Case testCase = TestDataFactory.createCase();
        CustomFeedComponentController.checkCaseStatus(testCase.Id);
    }
    
    @isTest static void testGetFeedCommentsByFeedItemId(){
        
        Case testCase = TestDataFactory.createCase();
        FeedItem testFeedItem = TestDataFactory.createFeedItem(testCase, 'TextPost', 'TextPost', 'AllUsers');
        
    	CustomFeedComponentController.getFeedCommentsByFeedItemId(testFeedItem.Id);    
    }
    
    @isTest static void testGetUserDetails(){
        CustomFeedComponentController.getCurrentUserDetails();
    }
    
}