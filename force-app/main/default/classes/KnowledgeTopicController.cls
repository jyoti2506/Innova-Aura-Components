public with sharing class KnowledgeTopicController {

    private static final String ERROR_NULL_CATEGORY = 'You cannot pass a blank category name to the getArticles method.';
    private static final String ERROR_NO_TOPIC = 'No topic found for the category';
    private static final String ERROR_TRENDING = 'Error while retrieving Trending Topics';
    
    //when logged in user queries TopicAssignment, sharing is utilized.  
    //only knowledge articles the user has access to will show in the TopicAssignment object.
    //however...per Jo, no articles for agents should ever appear in portal.
    @AuraEnabled(cacheable=true)
    public static List<Topic> getTopics() {
        
        Set<Id> topicIdSet = new Set<Id>();
        List<TopicAssignment> topicAssignments = [SELECT Topic.Name, EntityId, Entity.Name,EntityType FROM TopicAssignment Where EntityType = 'Knowledge'];
        
        Set<Id> endUserArticles = getAllEndUserArticles();
        
        for(TopicAssignment ta: topicAssignments){
            
            String kbId = ta.EntityId;
            
            if(endUserArticles.contains(kbId)) topicIdSet.add(ta.TopicId); 

        }
        
        List<Topic> topicList = new List<Topic>();
        topicList.add(new Topic(Name='Trending'));
        
        topicList.addAll(new List<Topic>([SELECT Id, Name FROM Topic Where Id IN :topicIdSet ORDER BY Name]));
        
        return topicList;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getArticles(String categoryName){
        
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        
        if(categoryName == null || categoryName == '') throw new KnowledgeTopicControllerException(ERROR_NULL_CATEGORY);
        if(categoryName == 'Trending') articles = getTrendingArticles();
        if(categoryName != 'Trending') articles = getArticlesByCategoryName(categoryName);
        
        return articles;
        
    }
    
    public static List<Knowledge__kav> getArticlesByCategoryName(String categoryName){
        
        Id topicId;
        
        try{
            topicId = [SELECT Id FROM Topic WHERE Name = :categoryName LIMIT 1].Id;
        } catch (Exception e){
            throw new KnowledgeTopicControllerException(ERROR_NO_TOPIC);
        }

        List<TopicAssignment> topicAssignments = [SELECT EntityId FROM TopicAssignment WHERE TopicId = :topicId LIMIT 1000];
        
        Set<Id> articleIdList = new Set<Id>();
        for (TopicAssignment ta : topicAssignments) {
            articleIdList.add(ta.EntityId);
        }
        
        List<Knowledge__kav> articlesToReturn = new List<Knowledge__kav>();
        Set<Id> includeSet = getAllEndUserArticles();
        
        for(Knowledge__kav k: [SELECT Id, Title, UrlName FROM Knowledge__kav WHERE Id IN :articleIdList AND PublishStatus = 'Online']){
            if(includeSet.contains(k.Id)) articlesToReturn.add(k);
            
        }
        
        return articlesToReturn;

    }
    
    //todo: get url of current environment
    //todo: get communityId of correct community
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getTrendingArticles(){
        System.debug('getTrendingArticles for Community: ' + Network.getNetworkId());
        
        Integer maxResults = 5;
        List<Knowledge__kav> articlesToReturn = new List<Knowledge__kav>();
        
        String sessionId = System.UserInfo.getSessionId(); //session of current user

        HttpRequest req = new HttpRequest();
        
        String baseURL = URL.getOrgDomainURL().toExternalForm();
		String communityId = Network.getNetworkId();
		String trendingURL = baseURL + '/services/data/v58.0/connect/communities/' + communityId + '/trending-articles?maxResults=' + maxResults;
        req.setEndpoint(trendingURL);
        //req.setEndpoint('https://innovasolutionsitsc--partialsb.sandbox.my.salesforce.com/services/data/v58.0/connect/communities/0DBDJ000000CcmW4AS/trending-articles');
        req.setMethod('GET'); 
        
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            
            String responseBody = res.getBody();
            //System.debug('Response Body: ' + responseBody);
            
            Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            
            List<Object> items = (List<Object>) parsedResponse.get('items');
            
            for (Object item : items) {
                
                Map<String, Object> itemMap = (Map<String, Object>) item;
                
                String id = (String) itemMap.get('id');
                String knowledgeArticleId = (String) itemMap.get('knowledgeArticleId'); //why are there two id's??? 
                String title = (String) itemMap.get('title');
                String urlName = (String) itemMap.get('urlName');
                
                
                Knowledge__kav article = new Knowledge__kav();
                article.Id = id;
                article.title = title;
                article.urlName = urlName; 
                
                articlesToReturn.add(article);
            }
            
        } else {
            throw new KnowledgeTopicControllerException (ERROR_TRENDING + ' Error: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
        
        System.debug('articles: ' + articlesToReturn);

        return articlesToReturn;
    }
    
    public static Set<Id> getAllEndUserArticles(){
        
        String dataCategoryName = 'End_Users'; //data category that is used for end user visible kb articles
        Set<Id> returnSet = new Set<Id>();
        
        for(Knowledge__DataCategorySelection d: [SELECT Id,DataCategoryGroupName, DataCategoryName, ParentId from Knowledge__DataCategorySelection]){
            if(d.DataCategoryName == dataCategoryName){
              returnSet.add(d.ParentId);
                System.debug('adding article: ' + d);
            } 
        }
        
        return returnSet;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getKnowledgeBodyById(String kbId){
        
        Knowledge__kav article = [SELECT Body__c,Title from Knowledge__kav Where Id = :kbId And PublishStatus  = 'Online' limit 1];
        
    return article.Body__c;

}
     @AuraEnabled(cacheable=true)
    public static String getArticleTitleById(String kbId){
        Knowledge__kav article = [SELECT Title FROM Knowledge__kav WHERE Id = :kbId AND PublishStatus = 'Online' LIMIT 1];
        return article != null ? article.Title : 'No title available';
    }

    public class KnowledgeTopicControllerException extends Exception{}
}