/**
 * @class TestUtils
 * @description Utility class for creating test data like Users and Cases for unit tests.
 */
@isTest
public class TestUtils {
  /**
   * @description Creates and returns a test user with the specified Permission Set assigned.
   * @param permissionSetName Name of the Permission Set to assign.
   * @return User A test user with the given permission.
   */
  public static User createTestUserWithPermission(String permissionSetName) {
    Profile profile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Standard User'
      LIMIT 1
    ];
    User user = new User(
      Username = 'permuser' + DateTime.now().getTime() + '@test.com',
      LastName = 'Test',
      Email = 'test@test.com',
      Alias = 'perm',
      TimeZoneSidKey = 'America/New_York',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ProfileId = profile.Id
    );
    insert user;

    PermissionSet permSet = [
      SELECT Id
      FROM PermissionSet
      WHERE Name = :permissionSetName
      LIMIT 1
    ];
    insert new PermissionSetAssignment(
      AssigneeId = user.Id,
      PermissionSetId = permSet.Id
    );

    return user;
  }

  /**
   * @description Creates and returns a test user without any Permission Sets.
   * @return User A basic test user without special permissions.
   */
  public static User createTestUserWithoutPermission() {
    Profile profile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Standard User'
      LIMIT 1
    ];
    User user = new User(
      Username = 'noperm' + DateTime.now().getTime() + '@test.com',
      LastName = 'Test',
      Email = 'noperm@test.com',
      Alias = 'noperm',
      TimeZoneSidKey = 'America/New_York',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ProfileId = profile.Id
    );
    insert user;
    return user;
  }

  /**
   * @description Creates and inserts a single Case record.
   * @param type Case type.
   * @param subject Case subject.
   * @param priority Case priority.
   * @param status Case status.
   * @return Case The inserted Case record.
   */
  public static Case createTestCase(
    String type,
    String subject,
    String priority,
    String status
  ) {
    Case c = new Case(
      Type = type,
      Subject = subject,
      Priority = priority,
      Status = status
    );
    insert c;
    return c;
  }

  /**
   * @description Creates and inserts multiple Case records from provided field maps.
   * @param caseDataList List of Maps containing Case field values.
   * @return List<Case> The inserted Case records.
   */
  public static List<Case> createTestCases(
    List<Map<String, String>> caseDataList
  ) {
    List<Case> casesToInsert = new List<Case>();

    for (Map<String, String> caseData : caseDataList) {
      Case c = new Case(
        Type = caseData.containsKey('Type') ? caseData.get('Type') : 'Problem',
        Subject = caseData.containsKey('Subject')
          ? caseData.get('Subject')
          : 'Default Subject',
        Priority = caseData.containsKey('Priority')
          ? caseData.get('Priority')
          : 'Medium',
        Status = caseData.containsKey('Status') ? caseData.get('Status') : 'New'
      );
      casesToInsert.add(c);
    }

    insert casesToInsert;
    return casesToInsert;
  }
}