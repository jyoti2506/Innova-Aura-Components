public class DateTimeUtils {

    /* 
     * purpose: UTC to logged in user's local timezone
     * param: utcDateTime DateTime
     * return: DateTime
     * 
	*/
    public static DateTime convertUTCToLocalTimezone(DateTime utcDateTime) {
        
        TimeZone userTimezone = UserInfo.getTimeZone();
        return utcDateTime.addSeconds(userTimezone.getOffset(utcDateTime) / 1000); 
        
    }
    
    /*
     * DateTime format of the logged in user.
     * Currently static and based on users locale 
	*/
    public static String getDateTimeFormatForUser(){
        
        String userLocale = UserInfo.getLocale();
            
        String format;
        
        //show timezone in local time zone
        if(userLocale == 'en_US') format = 'MM/dd/yyyy HH:mm a';
        if(userLocale == 'en_GB') format = 'dd-MM-yyyy hh:mm';
        if(userLocale == 'hi') format = 'dd-MM-yyyy hh:mm';
        
        return format;
        
    }

    
    /*
     * Get String representation of a DateTime 
	*/
    public static String formatDateTime(DateTime inputDateTime, String dateTimeFormat, String timezoneName) {
        
        if(inputDateTime == null || dateTimeFormat == null) throw new DateTimeUtilsException('Cannot pass null params to DateTimeUtils.formatDateTime');
        
        return inputDateTime.format(dateTimeFormat, timezoneName); 
    }
    
    public class DateTimeUtilsException extends Exception{}
}