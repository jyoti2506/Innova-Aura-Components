@isTest
public class KnowledgeControllerTest {
    
    @isTest static void testSelectedKnowledgeTitle(){
         Knowledge__kav testArticle = new Knowledge__kav(Title='Test Article', UrlName='test-article', IsVisibleInPkb=true);
        insert testArticle;
        
        KnowledgeController.getSelectedKnowledgeTitle(testArticle.Id);
        
    }

}