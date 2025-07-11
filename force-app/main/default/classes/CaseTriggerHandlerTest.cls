@isTest
private class CaseTriggerHandlerTest {
  @isTest
  static void testCreateNonconformance_WithPermission() {
    User testUser = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );

    System.runAs(testUser) {
      Test.startTest();
      Case caseRecord = TestUtils.createTestCase(
        'Problem',
        'Test Problem Case',
        'High',
        'New'
      );
      Test.stopTest();

      List<SQX_Nonconformance__c> ncList = [
        SELECT Id
        FROM SQX_Nonconformance__c
      ];
      System.assertEquals(
        1,
        ncList.size(),
        'One nonconformance should be created'
      );

      Case updatedCase = [
        SELECT SQX_NC_Reference__c
        FROM Case
        WHERE Id = :caseRecord.Id
      ];
      System.assertNotEquals(
        null,
        updatedCase.SQX_NC_Reference__c,
        'Case should be linked to NC'
      );
    }
  }

  @isTest
  static void testCreateNonconformance_WithoutPermission() {
    User noPermUser = TestUtils.createTestUserWithoutPermission();

    System.runAs(noPermUser) {
      Test.startTest();
      Case caseRecord = TestUtils.createTestCase(
        'Problem',
        'Test Without Permission',
        'Medium',
        'New'
      );
      Test.stopTest();

      List<SQX_Nonconformance__c> ncList = [
        SELECT Id
        FROM SQX_Nonconformance__c
      ];
      System.assertEquals(
        0,
        ncList.size(),
        'No NC should be created if user lacks permission'
      );

      Case fetchedCase = [
        SELECT SQX_NC_Reference__c
        FROM Case
        WHERE Id = :caseRecord.Id
      ];
      System.assertEquals(
        null,
        fetchedCase.SQX_NC_Reference__c,
        'Case should not be linked to NC'
      );
    }
  }

  @isTest
  static void testCreateNonconformance_WithPermissionOnUpdate() {
    User testUser = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );

    System.runAs(testUser) {
      Case caseRecord = TestUtils.createTestCase(
        'Other',
        'Test Problem Case',
        'High',
        'New'
      );

      Test.startTest();
      caseRecord.Type = 'Problem';
      update caseRecord;
      Test.stopTest();

      List<SQX_Nonconformance__c> ncList = [
        SELECT Id
        FROM SQX_Nonconformance__c
      ];
      System.assertEquals(
        1,
        ncList.size(),
        'One nonconformance should be created'
      );

      Case updatedCase = [
        SELECT SQX_NC_Reference__c
        FROM Case
        WHERE Id = :caseRecord.Id
      ];
      System.assertNotEquals(
        null,
        updatedCase.SQX_NC_Reference__c,
        'Case should be linked to NC'
      );
    }
  }

  @isTest
  static void testCreateNonconformance_InsertException() {
    User testUser = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );

    System.runAs(testUser) {
      Case c = new Case(
        Type = 'Problem',
        Subject = 'Trigger Insert Exception',
        Priority = 'Invalid data'
      );

      Test.startTest();
      CaseTriggerHandler handler = new CaseTriggerHandler();
      handler.createNonconformanceRecords(
        new List<Case>{ c },
        new Map<Id, Case>()
      );
      Test.stopTest();
    }
  }

  @isTest
  static void testBulkCreateNonconformance_WithPermission() {
    User testUser = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );

    System.runAs(testUser) {
      List<Map<String, String>> caseDataList = new List<Map<String, String>>{
        new Map<String, String>{
          'Type' => 'Problem',
          'Subject' => 'Bulk Case 1',
          'Priority' => 'High',
          'Status' => 'New'
        },
        new Map<String, String>{
          'Type' => 'Problem',
          'Subject' => 'Bulk Case 2',
          'Priority' => 'Medium',
          'Status' => 'New'
        },
        new Map<String, String>{
          'Type' => 'Question',
          'Subject' => 'Non-Problem Case',
          'Priority' => 'Low',
          'Status' => 'New'
        }
      };

      Test.startTest();
      List<Case> createdCases = TestUtils.createTestCases(caseDataList);
      Test.stopTest();

      List<SQX_Nonconformance__c> ncList = [
        SELECT Id, SQX_Title__c
        FROM SQX_Nonconformance__c
      ];
      System.assertEquals(
        2,
        ncList.size(),
        'Two nonconformance records should be created for Problem type cases'
      );

      List<Case> updatedCases = [
        SELECT Id, Type, SQX_NC_Reference__c
        FROM Case
        WHERE Id IN :createdCases AND Type = 'Problem'
      ];

      for (Case c : updatedCases) {
        System.assertNotEquals(
          null,
          c.SQX_NC_Reference__c,
          'Each Problem case should be linked to a NC'
        );
      }
    }
  }
}