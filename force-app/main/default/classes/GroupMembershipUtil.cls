public class GroupMembershipUtil {

    /**
     * 
     * Inner class. 
     * Represents the Group/Queue Membership that a user can have in Salesforce.
     * 
     */
	public class UserMembership {
        
        public Id recId;
        public String name;
        public String type; // 'Public Group' or 'Queue'
        
        /**
          * type: Public Group or a Queue
     	  * name: Name of the Public Group or Queue
     	  * recId = Id of the Public Group or Queue
     	  */ 

        public UserMembership(Id recId, String name, String type) {
            this.recId = recId;
            this.name = name;
            this.type = type;
        }
    }
    
    /**
     * Retrieves a set of Public Group or Queue Ids associated with a user, filtered by a provided type.
     *
     * @param userId The Id of the target user.
     * @param type The membership type to filter for ('Public Group' or 'Queue').
     * @return A set of Ids representing the memberships that match the given user and type.
     */
    public static Set<Id> getUserMembershipByType(Id userId, String type){
        
        Set<Id> userMembershipSet = new Set<Id>();
        
        for(UserMembership um: getUserMemberships(userId)){
            
            if(um.type == type){
            	userMembershipSet.add(um.recId);    
            }
            
        }
        
        return userMembershipSet;
    }
    
    /**
     * Retrieves a list of all Public Group and Queue memberships for a specified user, 
     * THIS INCLUDES NESTED.  RECURSIVELY CALLS findNestedGroups.
     *
     * @param userId The Id of the target user.
     * @return A list of UserMembership objects representing the user's memberships.
     */
    public static List<UserMembership> getUserMemberships(Id userId) {
        Set<Id> groupIds = new Set<Id>();
        List<UserMembership> memberships = new List<UserMembership>();

        // Get direct group and queue memberships
        for (GroupMember gm : [SELECT GroupId, Group.Name, Group.Type
                               FROM GroupMember 
                               WHERE UserOrGroupId = :userId]) {

            if (gm.Group.Type == 'Regular') { // Public Group
                memberships.add(new UserMembership(gm.GroupId, gm.Group.Name, 'Public Group'));
            } else if (gm.Group.Type == 'Queue') { // Queue
                memberships.add(new UserMembership(gm.GroupId, gm.Group.Name, 'Queue'));
            }

            groupIds.add(gm.GroupId);
        }

        // Recursively find nested group memberships
        findNestedGroups(groupIds, memberships); 

        return memberships;
    }
    
    
    /**
     * 
     * Recursive method. 
     * Find nested public group/queue memberships. 
     * Called internally by the getUserMemberships method.
     *
     * @param parentGroupIds A set of parent group Ids to search for child memberships.
     * @param memberships The list of UserMembership objects to be updated.
     * 
     */
    
    private static void findNestedGroups(Set<Id> parentGroupIds, List<UserMembership> memberships) {
        
        if (parentGroupIds.isEmpty()) {
            return; // Base case: No more parent groups
        }
    
        // Find child groups and queues
        List<GroupMember> childGroupMemberships = [SELECT GroupId, Group.Name, Group.Type  
                                                   FROM GroupMember 
                                                   WHERE UserOrGroupId IN :parentGroupIds];
    
        Set<Id> childGroupIds = new Set<Id>();
            
        for (GroupMember gm : childGroupMemberships) {
            childGroupIds.add(gm.GroupId);
    
            // Add to the memberships list
            memberships.add(new UserMembership(gm.GroupId, gm.Group.Name, gm.Group.Type)); 
        }
    
        // Recursion!  Call self with the newfound child groups
        findNestedGroups(childGroupIds, memberships);
	}   

  
}