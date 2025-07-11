/**
 * @class CaseTriggerHandler
 * @description Handles Case trigger logic for Nonconformance creation.
 */
public with sharing class CaseTriggerHandler {
  /**
   * @description Handles logic after Case insert.
   * @param newCases List of newly inserted Cases.
   */
  public void handleAfterInsert(List<Case> newCases) {
    createNonconformanceRecords(newCases, null);
  }

  /**
   * @description Handles logic after Case update.
   * @param newCases List of updated Cases.
   * @param oldCaseMap Map of old Case values.
   */
  public void handleAfterUpdate(List<Case> newCases, Map<Id, Case> oldCaseMap) {
    createNonconformanceRecords(newCases, oldCaseMap);
  }

  /**
   * @description Creates Nonconformance records for eligible Cases.
   * @param newCases List of Cases (insert or update).
   * @param oldCaseMap Old Case map (null if insert).
   */
  public void createNonconformanceRecords(
    List<Case> newCases,
    Map<Id, Case> oldCaseMap
  ) {
    if (!PermissionService.userHasPermission(Label.Case_Admin_Permission)) {
      return;
    }

    List<Case> problemCasesWithoutNC = CaseHelper.getProblemCasesWithoutNonconformance(
      newCases,
      oldCaseMap
    );
    if (problemCasesWithoutNC.isEmpty())
      return;

    Map<Id, SQX_Nonconformance__c> caseToNcMap = NonconformanceService.buildNonconformances(
      problemCasesWithoutNC
    );

    try {
      NonconformanceService.insertNonconformances(caseToNcMap.values());
      NonconformanceService.updateCasesWithNcRef(caseToNcMap);
    } catch (DmlException ex) {
      ErrorLogger.log('Insert or Update Nonconformance Error', ex);
    }
  }
}