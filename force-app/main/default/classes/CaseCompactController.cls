public class CaseCompactController {
    
    @AuraEnabled
    public static String getCaseRecord(String objectId){
        Case cc = [select id, RecordTypeId FROM CASE where Id = :objectId];
        return cc.RecordTypeId;
    }    
    
    @AuraEnabled
    public static String getJSONFieldSet(String sObjectName,String sFieldSetName){
        String sFieldSet='';
        sFieldSet=getFieldSet(sObjectName,sFieldSetName);
        return sFieldSet;
    }    
    
    public static String getFieldSet(String sObjectName,String fieldSetName) {
        String result = '';
        try{
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult d = objToken.getDescribe();
            Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
            system.debug('>>>>>>> FsMap >>> ' + FsMap);
            if(FsMap.containsKey(fieldSetName))
                for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                    if(result != ''){
                        result += ',';
                    }
                    String jsonPart = '{';
                    jsonPart += '"helpText":"' + gethelpText(sObjectName,f.getLabel()) + '",';
                    jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                    jsonPart += '"type":"' + (f.getType()) + '",';
                    jsonPart += '"label":"' + (f.getLabel()) + '",';
                    jsonPart += '"name":"' + f.getFieldPath() + '"';
                    jsonPart += '}';
                    result += jsonPart;
                }
        }
        catch(Exception e){
            result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return '['+result+']';
    }
    
    public static string gethelpText(String sObjectName,String sField){
        String helptext='';
        String[] types = new String[]{sObjectName};
            List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);
        for (Schema.DescribeSobjectResult result : results) {
            Map<String, Schema.SObjectField> fieldMap = result.fields.getMap();
            for(String fieldName :  fieldMap.keySet()){
                Schema.SObjectField field = fieldMap.get(fieldName);
                Schema.DescribeFieldResult f = field.getDescribe();
                if(f.getLabel()==sField){helptext=f.getInlineHelpText();
                                         if(helptext==null)helptext=f.getLabel();
                                        }
            }
        }
        return helptext;
    }
    
    @AuraEnabled
    public static List<wrapperC> getCase(String id, List<string> fieldList,List<String> fieldLabel){
        List<wrapperC> wrapperCList = new List<wrapperC>();
        
        
        string query = 'SELECT ';
        system.debug(fieldList);
        /*for(string f:fieldList){
query += f+',';
}*/
        for(integer i=0;i<fieldList.size();i++){
            if(i == fieldList.size()-1){
                query += fieldList[i];
            }
            else{
                query += fieldList[i]+',';
            }
        }
        
        query += ' FROM Case WHERE Id=:id';
        system.debug('Query---->'+query);
        
        List<Case> conDetail=Database.query(query);
        system.debug('conDetail---->'+ conDetail);
        
        Case c1 = conDetail[0];
        
        system.debug('This is da con~~~~}'+c1.get(fieldList[1]));
        for(String f : fieldList){
            List<String> fList= new List<String>();
            Map<String,Schema.SObjectField> mfields = Schema.Case.SObjectType.getDescribe().fields.getMap();
            Schema.DescribeFieldResult fieldResult = mfields.get(f).getDescribe();
            // fList.push(fieldResult);
            System.debug(fieldResult.getLabel());
        }
        
        for(integer i=0;i<fieldList.size();i++){
            wrapperC wrapperC1 = new wrapperC();
            /*Map<String,Schema.SObjectField> mfields = Schema.Case.SObjectType.getDescribe().fields.getMap();
Schema.DescribeFieldResult fieldResult = mfields.get(fieldList[i]).getDescribe(); */
            
            wrapperC1.label = fieldLabel[i];
            wrapperC1.value = string.valueOf(c1.get(fieldList[i]));
            
            if(wrapperC1.label == 'Created Date') {
                   
                DateTime utcDateTime = DateTime.valueOf(c1.get(fieldList[i]));
                DateTime localDateTime = DateTimeUtils.convertUTCToLocalTimezone(utcDateTime);
                String dateTimeFormat = DateTimeUtils.getDateTimeFormatForUser();
                
                TimeZone userTimezone = UserInfo.getTimeZone();
                String timezoneName = userTimezone.toString();
                
                wrapperC1.value = DateTimeUtils.formatDateTime(localDateTime, dateTimeFormat, timezoneName);
                
            }
            
            wrapperCList.add(wrapperC1);
            system.debug('wrapperC1~~~~}'+wrapperC1);
            
            
        }
        
        system.debug('Final Wrapper---->'+wrapperCList);
        
        return wrapperCList;
    }
    
    public class wrapperC{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value	{get;set;}
    }
}