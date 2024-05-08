/*
 * Compare Public Group Escalation field to actual Public Group Names.
 * If no match, display ERROR_MSG. 
*/

public class QueueOwnerCheck {
    
    public class QueueOwnerCheckException extends Exception {}
    
    private static final String FIELD_PUBLIC_GROUP = 'Innova_Public_Group_Escalation__c';
    private static final String ERROR_MSG = 'Public Group Name not found: ';
    
    private static Map<String,Group> groupMap;
    
    private Boolean isValid = false;
    private SObject publicGroupRecord;
    private String publicGroupName;
    
    //lazy load public groups
    //load once, store in groupMap variable, and then call groupMap on subsequent calls
    private static Map<String,Group> getGroupMap() {
        
        if( groupMap == null ){
        	groupMap = new Map<String,Group>();
            
            for(Group g: [Select Id, Name from Group Where Type = 'Regular']){
                groupMap.put(g.Name, g);
            }
            
        }
        
        return groupMap;
    }
    
    public QueueOwnerCheck(SObject publicGroupRecord){
        
        this.publicGroupRecord = publicGroupRecord;
        
        this.publicGroupName = (String)publicGroupRecord.get(FIELD_PUBLIC_GROUP);
        
        if(this.publicGroupName == null) return;       
        
        if(getGroupMap().containsKey(this.publicGroupName)){
            this.isValid = true;
            return;
        }
        
        publicGroupRecord.addError(ERROR_MSG + ' ' + this.publicGroupName);

    }
    
    //if Public Group Escalation is blank, set Public Group Id to null
    //if Public Group Escalation is a valid Public Group, set Public Group Id to corresponding Id
    public void setPublicGroupId(){
        
        
        if(!this.isValid){
            this.publicGroupRecord.put('Innova_Public_Group_Id__c',null);
        } else {
            this.publicGroupRecord.put('Innova_Public_Group_Id__c',groupMap.get(this.publicGroupName).Id);
        } 
   
    }
    


}