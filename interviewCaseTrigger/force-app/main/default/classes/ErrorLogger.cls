public class ErrorLogger {
  public static void log(String message, Exception ex) {
    System.debug('ERROR: ' + message + ' - ' + ex.getMessage());

    // Optional: Adding error into Object
    /*
        Error_Log__c log = new Error_Log__c(
            Message__c = message,
            Stack_Trace__c = ex.getStackTraceString(),
            User__c = UserInfo.getUserId()
        );
        insert log;
        */
  }
}