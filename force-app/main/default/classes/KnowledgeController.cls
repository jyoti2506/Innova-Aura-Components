public class KnowledgeController {
    
  @AuraEnabled
    public static String getSelectedKnowledgeTitle(Id recordId) {
        Knowledge__kav knowledge = [SELECT Title FROM Knowledge__kav WHERE Id = :recordId LIMIT 1];
        return knowledge.Title;
    }
}