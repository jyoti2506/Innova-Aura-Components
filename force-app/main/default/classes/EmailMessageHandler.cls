public class EmailMessageHandler {
    
    public static void AfterInsert(List<EmailMessage> triggerDotNew) {        
        new InnovaEmailProcessor(triggerDotNew); 
    }
       
}