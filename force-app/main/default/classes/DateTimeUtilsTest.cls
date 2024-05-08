@isTest
public class DateTimeUtilsTest {
    
    //todo: add assertions to ensure code is working as designed.

    public static testMethod void convertUTCToLocalTimezone(){
        
        DateTime dt = DateTime.now();
        
        DateTimeUtils.convertUTCToLocalTimezone(dt);
        
    }
    
    public static testMethod void getDateTimeFormatForUser(){
        
        DateTimeUtils.getDateTimeFormatForUser();
    }
    
    public static testMethod void formatDateTime(){
        
        DateTime dt = DateTime.now();
        
        DateTimeUtils.formatDateTime(dt, 'MM/dd/yyyy HH:mm a', 'America_Los_Angeles');
    }
}