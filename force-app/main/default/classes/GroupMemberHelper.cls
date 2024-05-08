global class GroupMemberHelper{
    
    public Map<id, Set<Id>> mapOfGroupIdToUsersOnly = new Map<id, Set<Id>>();
    public Map<id, Set<Id>> mapOfGroupIdToInnerGroups = new Map<id, Set<Id>>();
    public static Set<Id> userIdSet = new Set<Id>();
    public Map<Id, Id> GroupEscalationMap;
    public Map<String,Id> QueueMap;
    
    String publicGroupId;
    
    public GroupMemberHelper(){
        createMapsOfGroups();
    }
    
    
    public static Boolean isEnabled(){
        
        String isEnabled = 'false';

        try{
        	isEnabled = [Select Value__c From Innova_Group_Escalation__mdt Where DeveloperName = 'Active' limit 1].value__c;   
        } catch (Exception e){
            System.debug('Unable to query Innova_Group_Escalation__mdt custom metadata type.  Will not run.');
            return false;
        }
		

        if(isEnabled != null && isEnabled.toLowerCase() == 'true') return true;
        return false;
    }
    
    public GroupMemberHelper(Id ownerId){
        createMapsOfGroups();
        
        if(QueueMap == null){
            QueueMap = new Map<String,Id>();
            
            for(Group g: [Select Id,Name from Group Where Type = 'Queue']){
                QueueMap.put(g.Name,g.Id);
            }
        }
        
        if(GroupEscalationMap == null){
            GroupEscalationMap = new Map<Id,Id>();
            
            for(Innova_Queue_Owner__c qo: [Select Innova_Public_Group_Id__c, Queue_Name__c from Innova_Queue_Owner__c]){
                GroupEscalationMap.put(QueueMap.get(qo.Queue_Name__c),qo.Innova_Public_Group_Id__c);
            }
        }
        
        this.publicGroupId = GroupEscalationMap.get(ownerId);
    }
    
    public String getPublicGroupId(){
        return this.publicGroupId;
    }
    
    /*
    @invocableMethod(label='Get Comma Delimited List of Email Addresses in a Public Group')
    public static List<List<String>> getEmailList(List<List<String>> publicGroupIds){
        
        System.debug('ids: ' + publicGroupIds);
        
        List<String> emailList = new List<String>();
        List<List<String>> emailListList = new List<List<String>>();
        
        GroupMemberHelper gm = new GroupMemberHelper();
        
        for(Id publicGroupId : publicGroupIds[0]){
            gm.getAllPublicGroupUsers(publicGroupId); 
        }
                
        for(User u: [Select Email from User Where Id IN: userIdSet]){
            emailList.add(u.Email);
        }
        emailListList.add(emailList);
        
        System.debug('emailList: ' + emailList);
        return emailListList;
    } */
    
    public String getEmails(Id publicGroupId){
        System.debug('publicGroupId: ' + publicGroupId);
        getAllPublicGroupUsers(publicGroupId);
        
        System.debug('userIdSet: ' + userIdSet);
        List<User> userList = [Select Email from User Where Id IN: userIdSet limit 5];
        
        String emailCommaDelimited = '';
        
        for(User u: userList){
        	emailCommaDelimited += u.Email + ',';    
        }
        
        return emailCommaDelimited.removeEnd(',');

    }
    
    public Set<Id> getAllPublicGroupUsers(Id GroupId){
        if(mapOfGroupIdToUsersOnly != NULL && mapOfGroupIdToUsersOnly.containsKey(GroupId))
            userIdSet.addAll(mapOfGroupIdToUsersOnly.get(GroupId));
        
        if(mapOfGroupIdToInnerGroups.containsKey(GroupId)){
            for(Id eachInnerGroup : mapOfGroupIdToInnerGroups.get(GroupId)){
                getAllPublicGroupUsers(eachInnerGroup);
            }
        }
        
        return userIdSet;
    }

    public void createMapsOfGroups(){
        for(GroupMember eachGroupMember : [SELECT UserOrGroupId, GroupId, Group.Name FROM GroupMember where Group.Type = 'Regular'])
        {
            if(String.valueOf(eachGroupMember.UserOrGroupId).startsWith('005'))
            {
                if(!mapOfGroupIdToUsersOnly.containsKey(eachGroupMember.GroupId))
                    mapOfGroupIdToUsersOnly.put(eachGroupMember.GroupId, new Set<Id>());
                
                mapOfGroupIdToUsersOnly.get(eachGroupMember.GroupId).add(eachGroupMember.UserOrGroupId);
            }
            
            else if(String.valueOf(eachGroupMember.UserOrGroupId).startsWith('00G'))
            {
                if(!mapOfGroupIdToInnerGroups.containsKey(eachGroupMember.GroupId))
                    mapOfGroupIdToInnerGroups.put(eachGroupMember.GroupId, new Set<Id>());
                
                mapOfGroupIdToInnerGroups.get(eachGroupMember.GroupId).add(eachGroupMember.UserOrGroupId);
            }
        }
    }
}