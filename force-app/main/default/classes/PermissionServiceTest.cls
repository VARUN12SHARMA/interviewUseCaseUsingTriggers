@isTest
private class PermissionServiceTest {
  @isTest
  static void testUserHasPermission() {
    User user = TestUtils.createTestUserWithPermission(
      Label.Case_Admin_Permission
    );
    System.runAs(user) {
      Boolean result = PermissionService.userHasPermission(
        Label.Case_Admin_Permission
      );
      System.assertEquals(
        true,
        result,
        'Expected permission check to return true.'
      );
    }
  }

  @isTest
  static void testUserHasNoPermission() {
    User user = TestUtils.createTestUserWithoutPermission();
    System.runAs(user) {
      Boolean result = PermissionService.userHasPermission(
        Label.Case_Admin_Permission
      );
      System.assertEquals(
        false,
        result,
        'Expected permission check to return false.'
      );
    }
  }
}