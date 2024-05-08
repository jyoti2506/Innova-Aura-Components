public class ApprovalProcessId {
     @Future 
public static void recordTypeSetting(set<Id> parentObjectIds )
{
    if (!parentObjectIds.isEmpty())
    {
        map<Id, ProcessInstance> latestInstance = new map<Id, ProcessInstance>();
        for (ProcessInstance pi : [ SELECT Id, TargetObjectId, Status, CreatedDate,
                                        (
                                        SELECT Id, ProcessInstanceId, StepStatus, Comments, CreatedDate
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        )
                                        FROM ProcessInstance
                                        WHERE TargetObjectId IN: parentObjectIds
                                        ORDER BY CreatedDate DESC
                                    ])
        {
            system.debug('processInstance: ' + pi);
            system.debug('steps.size: ' + pi.Steps.Size());
            if (!latestInstance.containsKey(pi.TargetObjectId))
            {
                latestInstance.put(pi.TargetObjectId, pi);
            }
            else
            {
                ProcessInstance maxInstance = latestInstance.get(pi.TargetObjectId);
                if ( maxInstance.CreatedDate < pi.CreatedDate  )
                {
                    latestInstance.put(pi.TargetObjectId, pi);
                }
            }
        }
        set<Id> processInstanceIds = new set<Id>();
        for ( ProcessInstance pi : latestInstance.values())
        {
            for ( ProcessInstanceStep pis : pi.Steps)
            {
                if ( pis.StepStatus == 'Started')
                {
                    processInstanceIds.add( pi.Id );        
                }
            }
        }
        map<Id, ProcessInstanceNode> instanceNodeMap = new map<Id, ProcessInstanceNode>();
        for( ProcessInstanceNode node : [SELECT Id, NodeStatus, ProcessNodeName, ProcessInstanceId 
                                           FROM ProcessInstanceNode 
                                           WHERE ProcessInstanceId IN: processInstanceIds
                                           AND NodeStatus = 'Pending' ])
        {
            instanceNodeMap.put(node.ProcessInstanceId, node);
        }
        for ( Id parentObjectId : parentObjectIds )  
        {
            system.debug('Parent Object Id: ' + parentObjectId);
            ProcessInstance pi = latestInstance.get( parentObjectId );
            system.debug('process Instance: ' + pi );
            system.debug('current Active Step Name: ' + instanceNodeMap.get( pi.Id ).ProcessNodeName );
        } 
    }
}

}