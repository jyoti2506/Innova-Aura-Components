public class OpenCaseListView {
    private static final String CASE_QUERY = 'SELECT Id, CaseNumber, Subject, Status, CreatedDate, OwnerId, Innova_Region1__c, Innova_Brand1__c FROM Case';

    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(Integer pageSize, Integer pageNumber, String searchKeyword) {
        List<Case> caseList = new List<Case>();

        if (searchKeyword == null || searchKeyword.length() >= 3) {
            String query = getQuery(pageSize, pageNumber, searchKeyword);

            try {
                caseList = Database.query(query);

                // Reset pageNumber to 1 when there are search results
                if (!caseList.isEmpty()) {
                    pageNumber = 1;
                }
            } catch (Exception e) {
                System.debug('SOQL error when attempting to return Case records');
            }
        } else {
            String query = getQuery(pageSize, pageNumber, null);
            System.debug('query: ' + query);

            try {
                caseList = Database.query(query);
            } catch (Exception e) {
                System.debug('SOQL error when attempting to return Case records');
            }
        }

        return caseList;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getCasesTotal(String searchKeyword) {
        Integer casesTotal = -1;

        try {
            casesTotal = Database.query(getQuery(0, 0, searchKeyword)).size();
        } catch (Exception e) {
            System.debug('SOQL error when attempting to get Cases Total. Error: ' + e.getMessage());
        }

        return casesTotal;
    }

    @AuraEnabled(cacheable=true)
    public static String getUserTZ() {
        String tz;
        
        try {
            tz = [SELECT TimeZoneSidKey FROM User WHERE Id = :System.UserInfo.getUserId()].TimeZoneSidKey;
        } catch (Exception e) {
            throw new OpenCaseListViewException('Unable to retrieve TimeZone from current user.');
        }
        
        return tz;
    }

    // use custom metadata type
    private static Boolean isMyCases() {
        // return true;
        return false;
    }

    private static String getQuery(Integer pageSize, Integer pageNumber, String searchKeyword) {
        Id contactId = UserUtil.getContactIdByUserId(System.UserInfo.getUserId());
        Integer offset = (pageNumber - 1) * pageSize;
        
        // Limit the offset to 2000 records
        if (offset > 2000) {
            offset = 2000;
        }
        
        String soql = CASE_QUERY + ' WHERE Status NOT IN (\'Closed\', \'Resolved\')';
        // soql += 'AND ContactId = \'' + contactId + '\'';
                  
        if (!String.isBlank(searchKeyword)) {
            soql += ' AND (CaseNumber LIKE \'%' + searchKeyword + '%\' OR ' +
                    'Subject LIKE \'%' + searchKeyword + '%\' OR ' + 
                    'Status LIKE \'%' + searchKeyword + '%\')';
        }
        
        soql += ' ORDER BY CaseNumber DESC';
        
        if (pageSize > 0) soql += ' LIMIT ' + pageSize;
        if (offset > 0)   soql += ' OFFSET ' + offset;
    
        System.debug('search query: ' + soql);
        
        return soql;
    }
    
    public class OpenCaseListViewException extends Exception {}
}