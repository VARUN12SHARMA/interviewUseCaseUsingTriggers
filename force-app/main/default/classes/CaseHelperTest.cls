@isTest
private class CaseHelperTest {
  @isTest
  static void testProblemCases_Insert() {
    User testUser = TestUtils.createTestUserWithoutPermission();

    System.runAs(testUser) {
      List<Case> testCases = new List<Case>{
        new Case(Type = 'Problem', Priority = 'Medium', Subject = 'Case 1'),
        new Case(Type = 'Question', Priority = 'Low', Subject = 'Case 2')
      };

      List<Case> result = CaseHelper.getProblemCasesWithoutNonconformance(
        testCases,
        null
      );

      System.assertEquals(
        1,
        result.size(),
        'Only the Problem type case should be returned'
      );
      System.assertEquals(
        'Problem',
        result[0].Type,
        'Returned case must be of type Problem'
      );
    }
  }

  @isTest
  static void testProblemCases_Update() {
    User testUser = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );

    System.runAs(testUser) {
      Case oldCase = TestUtils.createTestCase(
        'Other',
        'Update Test Case',
        'Low',
        'New'
      );

      Case newCase = new Case(
        Id = oldCase.Id,
        Type = 'Problem',
        Priority = oldCase.Priority,
        Subject = oldCase.Subject,
        Origin = oldCase.Origin,
        Status = oldCase.Status
      );

      Map<Id, Case> oldMap = new Map<Id, Case>{ oldCase.Id => oldCase };

      List<Case> result = CaseHelper.getProblemCasesWithoutNonconformance(
        new List<Case>{ newCase },
        oldMap
      );

      System.assertEquals(
        1,
        result.size(),
        'Case changed to Problem type should be included in the result'
      );
      System.assertEquals(
        'Problem',
        result[0].Type,
        'Returned case must have updated type Problem'
      );
    }
  }
}