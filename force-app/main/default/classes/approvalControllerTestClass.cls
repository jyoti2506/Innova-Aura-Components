@isTest
public class approvalControllerTestClass {
    
    @TestSetup
    public static void CreateTestData(){
               
        Integer numOfRecs = 30;
        
        List<SObject> recordList = new List<SObject>();
        
        List<SObject> caseList = getCases(numOfRecs);
        List<SObject> changeList = getChanges(numOfRecs);
        
        recordList.addAll(caseList);
        recordList.addAll(changeList);
        
        System.debug('added ' + recordList.size() + ' records');
        insert recordList;
        
        List<Approval.ProcessSubmitRequest> approvals = new List<Approval.ProcessSubmitRequest>();
        
        for(SObject s: recordList){
            
            Approval.ProcessSubmitRequest approval = new Approval.ProcessSubmitRequest();
            
            approval.setComments('Submitting request for approval.');
        	approval.setObjectId(s.id);
        	approval.setSubmitterId(UserInfo.getUserId()); 
        	approval.setSkipEntryCriteria(true);
            approval.setNextApproverIds(new List<Id>{System.UserInfo.getUserId()});
            
            approvals.add(approval);
        }
        
        
        List<Approval.ProcessResult> approvalResults = Approval.process(approvals);
        
        //System.assert(approvalResults.isSuccess());
    }
    
    @isTest
    public static void getSubmittedRecordsTest(){
        List<approvalController.SubmittedRecordsWrapper> submitRecList = approvalController.getSubmittedRecords();
        List<Case> caseRecords =[SELECT Id, Subject FROM Case WHERE SuppliedCompany='Test Data 007'];
       // system.assertEquals(caseRecord.Id, submitRecList[0].recordId);
    }
    
    @isTest
    public static void processRecordsTest(){
        List<String>IdList = new List<String>();
        List<Case> caseRecords =[SELECT Id, Subject FROM Case WHERE SuppliedCompany='Test Data 007'];
 
        List<ProcessInstance> ps=  [ SELECT Id FROM ProcessInstance WHERE TargetObjectId in:caseRecords];
        system.debug('Process Instance'+ps);
        ProcessInstanceWorkitem pIWI = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem 
                                        WHERE ProcessInstanceId=:ps[0].Id];
        IdList.add(pIWI.Id);
       
        
        String result = approvalController.processRecords(IdList,'Approve','Testy Comments');
        system.assertEquals('All records are Approved successfully', result);
    }
    
    private static List<SObject> getCases(Integer numOfRecs){
        
        List<Case> caseList = new List<Case>();
        
        for(Integer i=0; i < numOfRecs; i++){
            
            Case caseRecord = new Case(Status='New',Origin='Phone',Subject='Case For User Approval', SuppliedCompany='Test Data 007');
            
            caseList.add(caseRecord);
        }
        
       return caseList;
        
    }
    
    private static List<SObject> getChanges(Integer numOfRecs){
        
        List<ChangeRequest> changeList = new List<ChangeRequest>();
        
        for(Integer i=0; i < numOfRecs; i++){
            ChangeRequest cr = new ChangeRequest();
            
            cr.Subject = 'test subject';
			cr.Description = 'test description';
			cr.Status = 'New';
			cr.Category = 'DNS';
			cr.Priority = 'Low';
			cr.Impact = 'Low'; 
			cr.RiskLevel = 'Low';
			cr.Implementation_Plan__c = 'impl plan';
			cr.Test_Plan__c = 'test plan';
			cr.Roll_Back_Plan__c = 'roll back plan';
            
            changeList.add(cr);
        }
        
        return changeList;
    }
    
    
    
    
}