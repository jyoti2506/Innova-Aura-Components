@isTest
private class KnowledgeTopicControllerTest {

    @isTest static void testGetTopics() {
        // Create test data
        Topic testTopic = new Topic(Name='TestTopic');
        insert testTopic;
        
        Knowledge__kav testArticle = new Knowledge__kav(Title='Test Article', UrlName='test-article', IsVisibleInPkb=true);
        insert testArticle;
        
        // Manually insert TopicAssignment record
        TopicAssignment ta = new TopicAssignment(TopicId=testTopic.Id, EntityId=testArticle.Id);
        insert ta;
        
        // Test the getTopics method
        Test.startTest();
        List<Topic> topics = KnowledgeTopicController.getTopics();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(2, topics.size(), 'Expected 2 topics: "Trending" and "TestTopic"');
        System.assertEquals('Trending', topics[0].Name);
        System.assertEquals('TestTopic', topics[1].Name);
    }

    @isTest static void testGetArticlesByCategoryName() {
        // Create test data
        Topic testTopic = new Topic(Name='TestTopic');
        insert testTopic;
        
        Knowledge__kav testArticle = new Knowledge__kav(Title='Test Article', UrlName='test-article', IsVisibleInPkb=true);
        insert testArticle;
        
        // Manually insert TopicAssignment record
        TopicAssignment ta = new TopicAssignment(TopicId=testTopic.Id, EntityId=testArticle.Id);
        insert ta;

        // Test the getArticlesByCategoryName method
        Test.startTest();
        List<Knowledge__kav> articles = KnowledgeTopicController.getArticlesByCategoryName('TestTopic');
        Test.stopTest();
        
        // Verify results
        System.assertEquals(1, articles.size(), 'Expected 1 article');
        System.assertEquals('Test Article', articles[0].Title);
    }

    @isTest static void testGetTrendingArticles() {
        // Mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Test the getTrendingArticles method
        Test.startTest();
        List<Knowledge__kav> articles = KnowledgeTopicController.getTrendingArticles();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(1, articles.size(), 'Expected 1 trending article');
        System.assertEquals('Trending Article', articles[0].title);
        System.assertEquals('trending-article', articles[0].urlName);
    }

    @isTest static void testGetKnowledgeBodyById() {
        // Create test data
        Knowledge__kav testArticle = new Knowledge__kav(Title='Test Article', Body__c='Test body', IsVisibleInPkb=true);
        insert testArticle;

        // Test the getKnowledgeBodyById method
        Test.startTest();
        String body = KnowledgeTopicController.getKnowledgeBodyById(testArticle.Id);
        Test.stopTest();

        // Verify results
        System.assertEquals('Test body', body, 'Expected the correct article body');
    }

    @isTest static void testGetArticlesWithNullCategoryName() {
        // Test getArticles method with null category name
        Test.startTest();
        try {
            KnowledgeTopicController.getArticles(null);
        } catch (KnowledgeTopicController.KnowledgeTopicControllerException e) {
            System.assertEquals('You cannot pass a blank category name to the getArticles method.', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest static void testGetArticlesWithInvalidCategoryName() {
        // Test getArticles method with invalid category name
        Test.startTest();
        try {
            KnowledgeTopicController.getArticles('InvalidCategory');
        } catch (KnowledgeTopicController.KnowledgeTopicControllerException e) {
            System.assertEquals('No topic found for the category', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest static void testGetTrendingArticlesHttpError() {
        // Mock HTTP callout to simulate an error
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseErrorGenerator());

        // Test getTrendingArticles method with HTTP error
        Test.startTest();
        try {
            KnowledgeTopicController.getTrendingArticles();
        } catch (KnowledgeTopicController.KnowledgeTopicControllerException e) {
            System.assertEquals('Error while retrieving Trending Topics', e.getMessage());
        }
        Test.stopTest();
    }

    // Mock HTTP response for getTrendingArticles method
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"items":[{"id":"12345","knowledgeArticleId":"67890","title":"Trending Article","urlName":"trending-article"}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Mock HTTP response for getTrendingArticles method with HTTP error
    public class MockHttpResponseErrorGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            return res;
        }
    }
}