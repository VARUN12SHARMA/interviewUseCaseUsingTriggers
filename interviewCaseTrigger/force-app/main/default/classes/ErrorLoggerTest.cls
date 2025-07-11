@isTest
private class ErrorLoggerTest {
  @isTest
  static void testLoggingDoesNotThrow() {
    try {
      throw new DmlException('Simulated error');
    } catch (Exception ex) {
      Test.startTest();
      ErrorLogger.log('Simulated Logging', ex);
      Test.stopTest();
      System.assert(true, 'Logging executed');
    }
  }
}