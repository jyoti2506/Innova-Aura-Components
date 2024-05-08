public without sharing class CustomFeedComponentController {
    
    public class InnovaFeedException extends Exception{}
    
    @AuraEnabled
    public static User getCurrentUserDetails() {
        return [SELECT Id, Name, MediumPhotoUrl FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }
    
    public class ItemComparator implements Comparator<FeedItemWrapper> {
        public Integer compare(FeedItemWrapper a, FeedItemWrapper b) {
            Datetime aDate = (a.feedItem != null) ? a.feedItem.CreatedDate : a.emailMessage.CreatedDate;
            Datetime bDate = (b.feedItem != null) ? b.feedItem.CreatedDate : b.emailMessage.CreatedDate;
            if (aDate > bDate) {
                return -1;
            } else if (aDate < bDate) {
                return 1;
            } else {
                return 0;
            }
        }
    }
    
    @AuraEnabled
    public static List<feedCommentWrapper> getFeedCommentsByFeedItemId(String feedItemId){
        
        List<feedCommentWrapper> feedCommentList = new List<feedCommentWrapper>();
        
        for(FeedComment fc: [SELECT CommentBody,ParentId,CreatedById,CreatedDate,FeedItemId FROM FeedComment WHERE FeedItemId = :feedItemId ORDER BY CreatedDate DESC]){
            system.debug('fc:' + fc);
            feedCommentWrapper fcw = new feedCommentWrapper(fc);
            feedCommentList.add(fcw);
        }
        
        return feedCommentList;
    }
    
    @AuraEnabled
    public static String checkCaseStatus(String recordId) {
        Case caseRecord = [SELECT Id, Status FROM Case WHERE Id = :recordId LIMIT 1];
        return caseRecord.Status;
    }
    @AuraEnabled
    public static List<FeedItemWrapper> getCaseCommentswithEmail_old(String caseRecordId) {
        List<FeedItemWrapper> commentsWithFormattedTime = new List<FeedItemWrapper>();
        // Query FeedItem and FeedComment
        Map<DateTime, FeedItem> feedItems = new Map<DateTime, FeedItem>();
        for (FeedItem feedItem : [SELECT Id, ParentId, Body, CreatedById, CreatedDate, Type, Visibility 
                                  FROM FeedItem 
                                  WHERE ParentId = :caseRecordId 
                                  AND (Type = 'TextPost' OR Type = 'EmailMessageEvent') 
                                  AND Visibility = 'AllUsers'
                                  ORDER BY CreatedDate DESC]) {
                                      feedItems.put(feedItem.CreatedDate, feedItem);
                                  }
        Set<Id> feedItemIds = new Set<Id>();
        for (FeedItem feedItem : feedItems.values()) {
            feedItemIds.add(feedItem.Id);
        }  
        List<EmailMessage> emailMessages = [SELECT Id, ParentId, Subject, HtmlBody, FromAddress, CreatedDate,EmailTemplateId 
                                            FROM EmailMessage 
                                            WHERE ParentId = :caseRecordId ORDER BY CreatedDate DESC];
        // Create FeedItemWrapper instances for feed items
        for (FeedItem feedItem : feedItems.values()) {
            commentsWithFormattedTime.add(new FeedItemWrapper(feedItem));
        }
        // Create FeedItemWrapper instances for email messages
        for (EmailMessage emailMessage : emailMessages) {
            DateTime emailMessageContent = emailMessage.CreatedDate; // You can also use emailMessage.HtmlBody if you want to match based on the email body content
            FeedItem correspondingFeedItem = feedItems.get(emailMessageContent);
            
            if (correspondingFeedItem != null) {
                commentsWithFormattedTime.add(new FeedItemWrapper(emailMessage, correspondingFeedItem.Id));
            } else {
                commentsWithFormattedTime.add(new FeedItemWrapper(emailMessage, null)); // No corresponding FeedItem
            }
        }        
        commentsWithFormattedTime.sort(new ItemComparator());
        return commentsWithFormattedTime;
    }
    
    @AuraEnabled
    public static List<FeedItemWrapper> getCaseCommentswithEmail(String caseRecordId){
        List<FeedItemWrapper> fiwList = new List<FeedItemWrapper>();
        for (FeedItem fi : [SELECT Id, ParentId, Body, CreatedById, CreatedDate, Type, Visibility 
                            FROM FeedItem 
                            WHERE ParentId = :caseRecordId 
                            AND ((Type = 'TextPost' AND Visibility = 'AllUsers') OR (Type = 'EmailMessageEvent'))
                            ORDER BY CreatedDate DESC]) {
                                if(fi.Type == 'TextPost'){
                                    FeedItemWrapper fiw = new FeedItemWrapper(fi);    
                                    fiwList.add(fiw);
                                } 
                                else if(fi.Type=='EmailMessageEvent'){
                                    EmailMessage em = getEmailMessageByFeedItemId(fi.Id);
                                    FeedItemWrapper fiw = new FeedItemWrapper(em,fi.Id);
                                    fiwList.add(fiw);
                                } 
                            }
        fiwList.sort(new ItemComparator());
        for(FeedItemWrapper fiw: fiwList){
            System.debug('the created Date: ' + fiw.CreatedDate + 'the msg: ' + fiw.Body);
        }
        return fiwList;
    }
    
    //needs error handling!
    @AuraEnabled
    public static EmailMessage getEmailMessageById(String emailMessageId){
        
        EmailMessage em = new EmailMessage();
        
        em = [SELECT FromAddress, MessageDate, HtmlBody, ParentId, CreatedDate, Subject 
              FROM EmailMessage 
              WHERE Id = :emailMessageId];
        
        return em;
    }
    
    //must revisit.
    //Locates EmailMessage based on a fuzzy search of datetime, 
    //i.e., EmailMessage.MessageDate = FeedItem.CreatedDate +- 2 seconds 
    
    
    @AuraEnabled
    public static EmailMessage getEmailMessageByFeedItemId(String feedItemId){
        
        EmailMessage em = new EmailMessage();
        
        System.debug('feedItemId: ' + feedItemId);
        FeedItem fi = [SELECT CreatedDate, ParentId FROM FeedItem WHERE Id = :feedItemId limit 1];
        
        DateTime createdDate = fi.CreatedDate;
        String caseId = fi.ParentId;
        
        DateTime lowerBound = createdDate.addSeconds(-2);
        DateTime upperBound = createdDate.addSeconds(2);
        
        System.debug('createdDate: ' + createdDate);
        System.debug('lowerBound: ' + lowerBound);
        System.debug('upperBound: ' + upperBound);
        
        String query = 'SELECT FromAddress, MessageDate, HtmlBody FROM EmailMessage WHERE ParentId = \'' + caseId + '\' AND CreatedDate >= \'' + lowerBound + '\' AND CreatedDate <= \'' + upperBound + '\'';
        
        System.debug('Email query: ' + query);
        
        em = [SELECT FromAddress, MessageDate, HtmlBody, ParentId, CreatedDate, Subject 
              FROM EmailMessage 
              WHERE ParentId = :caseId 
              AND MessageDate >= :lowerBound AND MessageDate <= :upperBound
              LIMIT 1];
        
        return em;
    } 
    @AuraEnabled
    public static List<Object> getCaseComments(String caseRecordId) {
        Map<String, Object> result = new Map<String, Object>();
        List<feedCommentWrapper> feedCommentWrapperTime = new List<feedCommentWrapper>();
        // Query FeedItem and FeedComment
        List<FeedItem> feedItems = [SELECT Id, ParentId, Body, CreatedById, CreatedDate, Type, Visibility 
                                    FROM FeedItem 
                                    WHERE ParentId = :caseRecordId AND (Type = 'TextPost' OR Type = 'EmailMessageEvent') AND Visibility = 'AllUsers'
                                    ORDER BY CreatedDate DESC];
        Set<String> feedItemIds = new Set<String>();
        for (FeedItem feedItem : feedItems) {
            feedItemIds.add(feedItem.Id);
        }
        List<FeedComment> feedComments = [SELECT Id, FeedItemId, CommentBody, CreatedById, CreatedDate,ParentId
                                          FROM FeedComment
                                          WHERE FeedItemId IN :feedItemIds ORDER BY CreatedDate DESC];
        for (FeedComment feed : feedComments) {
            feedCommentWrapper feedtWrapper = new feedCommentWrapper(feed);
            feedCommentWrapperTime.add(feedtWrapper);
        }
        return feedCommentWrapperTime;
    }
    
   @AuraEnabled
    public static String createFeedCommentMethod(String feedItemId, String postContent) {
        FeedComment chatterPost = new FeedComment();
        try {          
            String userId = UserInfo.getUserId();
            // Create a FeedItem for the Chatter post
            List<FeedItem> feedItems = [
                SELECT Id, CreatedDate, Type 
                FROM FeedItem 
                WHERE Id = :feedItemId AND (Type = 'EmailMessageEvent' OR Type = 'TextPost') 
                LIMIT 1
            ];
            
            if (feedItems.size() > 0) {
                chatterPost.FeedItemId = feedItems[0].Id; 
            } else {
                EmailMessage email = [Select Id,CreatedDate from EmailMessage where Id =:feedItemId];
                DateTime twoMinutesAgo = email.CreatedDate.addMinutes(-2);
                List<FeedItem> feedItemList = [
                    Select Id,CreatedDate,Type 
                    From FeedItem 
                    Where CreatedDate >= :twoMinutesAgo AND Type= 'EmailMessageEvent'
                    LIMIT 1
                ];
                if (feedItemList.size() > 0) {
                    chatterPost.FeedItemId = feedItemList[0].Id;
                }
            }
           chatterPost.CommentBody = stripHtmlTags(postContent);  // Remove HTML tags
            chatterPost.CreatedById = userId; 
            chatterPost.CommentType = 'TextComment';   
            insert chatterPost;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Chatter post: ' + e.getMessage());
        }
        return chatterPost.FeedItemId;
    }

    
    
   @AuraEnabled
public static void createChatterPost(String recordId, String postContent) {
    try {
        String userId = UserInfo.getUserId();
        
        // Create a FeedItem for the Chatter post
        List<FeedItem> feedItems = [
            SELECT Id 
            FROM FeedItem 
            WHERE ParentId = :recordId AND Type = 'TextPost' 
            LIMIT 1
        ];

        // Fetch ContentPost from CollaborationGroupFeed
        List<CollaborationGroupFeed> contentPosts = [
            SELECT Parent.Id, ParentId, LinkUrl, Id, RelatedRecordId 
            FROM CollaborationGroupFeed 
            WHERE ParentId = :recordId AND Type = 'ContentPost' 
            LIMIT 1
        ];
        
        FeedItem chatterPost = new FeedItem();
        
        chatterPost.ParentId = recordId; 
        chatterPost.Body = stripHtmlTags(postContent);  // Remove HTML tags
        chatterPost.CreatedById = userId; 
        chatterPost.Type = 'TextPost';   
        chatterPost.Visibility = 'AllUsers';
        
        insert chatterPost;
        
        system.debug('chatterPost' + chatterPost);
        // Handle ContentPost if fetched
        
        if(contentPosts.size() > 0) {
            CollaborationGroupFeed contentPost = contentPosts[0];
            
        }

    } catch (Exception e) {
        throw new AuraHandledException('Error creating Chatter post: ' + e.getMessage());
    }
}
    
    
    @AuraEnabled
    public static String stripHtmlTags(String html) {
        return html.replaceAll('<[^>]+>', '');
    }
    
    public class FeedItemWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String ParentId;
        @AuraEnabled public String Body;
        @AuraEnabled public String CreatedById;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String Type;
        @AuraEnabled public String Visibility;
        @AuraEnabled public String formattedTime;
        @AuraEnabled public String CommentBody;
        @AuraEnabled public String CommenterName;
        @AuraEnabled public String CommenterProfilePicUrl; 
        @AuraEnabled public String Subject;
        @AuraEnabled public String FromAddress;
        @AuraEnabled public String ObjectType;
        @AuraEnabled public FeedItem feedItem;
        @AuraEnabled public EmailMessage emailMessage;
        @AuraEnabled public String FeedValue;
        
        public FeedItemWrapper(FeedItem feedItem) {
            this.feedItem = feedItem;
            this.Id = feedItem.Id;
            this.ParentId = feedItem.ParentId;
            this.Body = feedItem.Body;
            this.CreatedById = feedItem.CreatedById;
            this.CreatedDate = feedItem.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'UTC');
            this.Type = feedItem.Type;
            this.Visibility = feedItem.Visibility;
            this.ObjectType = 'FeedItem'; // Identifying the object type as FeedItem
            this.formattedTime = getFormattedTimeDifference(feedItem.CreatedDate);
            this.CommentBody = '';
            this.CommenterName = '';
            this.CommenterProfilePicUrl = ''; 
            if (feedItem.Type == 'EmailMessageEvent') {
                // Populate subject and from address only for EmailMessageEvent type
                this.Subject = ''; // Default value
                this.FromAddress = ''; // Default value
                this.ObjectType = 'EmailMessage'; // Identifying the object type as EmailMessage
            } else {
                // Add logic to query for the commenter's name and profile image URL
                if (feedItem.CreatedById != null) {
                    User commenter = [SELECT Name, MediumPhotoUrl FROM User WHERE Id = :feedItem.CreatedById LIMIT 1];
                    this.CommenterName = commenter.Name;
                    this.CommenterProfilePicUrl = commenter.MediumPhotoUrl;
                }
            }
        }
        
        public FeedItemWrapper(EmailMessage emailMessage, string FeedValue) {
            this.emailMessage = emailMessage;
            this.Id = emailMessage.Id;
            this.FeedValue= FeedValue;
            this.ParentId = emailMessage.ParentId;
            //this.Body = emailMessage.TextBody;
            this.Body = emailMessage.HtmlBody;
            this.CreatedById = ''; // Since it's an email message, there's no created by ID
            this.CreatedDate = emailMessage.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'UTC');
            this.Type = 'EmailMessageEvent';
            this.Visibility = ''; // Adjust visibility if needed
            this.ObjectType = 'EmailMessage'; // Identifying the object type as EmailMessage
            this.formattedTime = getFormattedTimeDifference(emailMessage.CreatedDate);
            this.CommentBody = '';
            this.CommenterName = emailMessage.FromAddress;
            this.CommenterProfilePicUrl = ''; 
            this.Subject = emailMessage.Subject;
            this.FromAddress = emailMessage.FromAddress;
        }
    }
    
    public class feedCommentWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String ParentId;
        @AuraEnabled public String feedItemId;
        @AuraEnabled public String CreatedById;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String formattedTime;
        @AuraEnabled public String CommentBody;
        @AuraEnabled public String CommenterName;
        @AuraEnabled public String CommenterProfilePicUrl; 
        public feedCommentWrapper(FeedComment feedComment) {
            this.Id = feedComment.Id;
            this.ParentId = feedComment.ParentId;
            this.CreatedById = feedComment.CreatedById;
            this.CreatedDate = feedComment.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'UTC');
            this.formattedTime = getFormattedTimeDifference(feedComment.CreatedDate);
            this.CommentBody =feedComment.CommentBody;
            this.CommenterName = '';
            this.CommenterProfilePicUrl = ''; 
            this.feedItemId = feedComment.FeedItemId;
            // Add logic to query for the commenter's name and profile image URL
            if (feedComment.CreatedById != null) {
                User commenter = [SELECT Name, MediumPhotoUrl FROM User WHERE Id = :feedComment.CreatedById LIMIT 1];
                this.CommenterName = commenter.Name;
                this.CommenterProfilePicUrl = commenter.MediumPhotoUrl;
            }
        }
    }
    
    public class EmailMessageWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String ParentId;
        @AuraEnabled public String Subject;
        @AuraEnabled public String TextBody;
        @AuraEnabled public String FromAddress;
        @AuraEnabled public String CreatedDate;
        public EmailMessageWrapper(EmailMessage emailMessage) {
            this.Id = emailMessage.Id;
            this.ParentId = emailMessage.ParentId;
            this.Subject = emailMessage.Subject;
            //this.TextBody = emailMessage.TextBody;
            this.TextBody = emailMessage.HtmlBody;
            this.FromAddress = emailMessage.FromAddress;
            
            this.CreatedDate = emailMessage.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'UTC');
        }
    }
    
    @AuraEnabled
    public static String getFormattedTimeDifference(Datetime commentDateTime) {
        
        TimeZone userTimezone = UserInfo.getTimeZone();
        String userTimezoneName = userTimezone.toString();
        DateTime localDateTime = DateTimeUtils.convertUTCToLocalTimezone(commentDateTime);
        String format = DateTimeUtils.getDateTimeFormatForUser();
        
        return DateTimeUtils.formatDateTime(localDateTime, format, userTimezoneName);
        
    }
    
}