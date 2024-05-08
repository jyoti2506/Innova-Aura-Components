public without sharing class MyFieldSetApexClass {

    public MyFieldSetApexClass() {
    }

    public static List<Schema.FieldSetMember> getFields() {
        return SObjectType.Case.FieldSets.Case_Deatil.getFields();
    }

    @AuraEnabled(cacheable=true)
    public static Case getCaseList(id caseid) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : MyFieldSetApexClass.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Case WHERE ID=\''+caseid+'\'';
        System.debug(query);
        return Database.query(query);
    }
}