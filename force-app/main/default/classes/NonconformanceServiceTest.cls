@isTest
private class NonconformanceServiceTest {
  @isTest
  static void testBuildNonconformance() {
    Case testCase = new Case(
      Subject = 'Issue',
      Priority = 'High',
      Description = 'Desc'
    );
    insert testCase;
    Map<Id, SQX_Nonconformance__c> result = NonconformanceService.buildNonconformances(
      new List<Case>{ testCase }
    );
    System.assertEquals(1, result.size(), 'One record build should be created');
    System.assertEquals(
      'Issue',
      result.get(testCase.Id).SQX_Title__c,
      'The field SQX_Title__c should be the same as the Case Subject'
    );
  }

  @isTest
  static void testInsertAndUpdateFlow() {
    Case testCase = new Case(
      Subject = 'Test Case',
      Type = 'Problem',
      Priority = 'High',
      Status = 'New'
    );
    insert testCase;

    Map<Id, SQX_Nonconformance__c> ncMap = NonconformanceService.buildNonconformances(
      new List<Case>{ testCase }
    );

    Test.startTest();
    NonconformanceService.insertNonconformances(ncMap.values());
    NonconformanceService.updateCasesWithNcRef(ncMap);
    Test.stopTest();

    Case updatedCase = [
      SELECT SQX_NC_Reference__c
      FROM Case
      WHERE Id = :testCase.Id
    ];
    System.assertNotEquals(
      null,
      updatedCase.SQX_NC_Reference__c,
      'The Case should be linked to NC'
    );
  }
}