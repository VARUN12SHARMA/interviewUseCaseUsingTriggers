/**
 * @class PermissionService
 * @description Utility class to check user permissions via assigned Permission Sets.
 */
public with sharing class PermissionService {
  /**
   * @description Checks if the current user has the given Permission Set.
   * @param permissionSetName Name of the Permission Set to check.
   * @return Boolean True if the user has the permission, otherwise false.
   */
  public static Boolean userHasPermission(String permissionSetName) {
    return [
        SELECT Id
        FROM PermissionSetAssignment
        WHERE
          AssigneeId = :UserInfo.getUserId()
          AND PermissionSet.Name = :permissionSetName
        WITH SECURITY_ENFORCED
        LIMIT 1
      ]
      .size() > 0;
  }
}