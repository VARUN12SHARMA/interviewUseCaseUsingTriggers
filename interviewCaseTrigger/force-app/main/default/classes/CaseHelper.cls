/**
 * @class CaseHelper
 * @description Utility class that provides helper methods for evaluating Case records,
 * specifically for identifying 'Problem' cases that require Nonconformance creation.
 */
public with sharing class CaseHelper {
  /**
   * Constant representing the 'Problem' Case type.
   */
  public static final String CASE_TYPE_PROBLEM = 'Problem';

  /**
   * @description
   * Identifies Case records that should trigger Nonconformance creation.
   * - On insert (when oldCaseMap is null), includes all new cases of Type 'Problem'.
   * - On update, includes only those cases that changed to Type 'Problem' and have no NC reference.
   *
   * @param currentCases List of Case records from Trigger.new.
   * @param oldCaseMap Map of old Case records (Trigger.oldMap), or null if insert context.
   * @return List<Case> Cases that meet the criteria for Nonconformance creation.
   */
  public static List<Case> getProblemCasesWithoutNonconformance(
    List<Case> currentCases,
    Map<Id, Case> oldCaseMap
  ) {
    List<Case> problemCasesToProcess = new List<Case>();

    for (Case currentCase : currentCases) {
      if (oldCaseMap == null && currentCase.Type == CASE_TYPE_PROBLEM) {
        problemCasesToProcess.add(currentCase);
      } else if (oldCaseMap != null) {
        Case previousCase = oldCaseMap.get(currentCase.Id);
        Boolean changedToProblemType =
          currentCase.Type == CASE_TYPE_PROBLEM &&
          previousCase?.Type != CASE_TYPE_PROBLEM;
        Boolean noExistingNonconformance =
          currentCase.SQX_NC_Reference__c == null;

        if (changedToProblemType && noExistingNonconformance) {
          problemCasesToProcess.add(currentCase);
        }
      }
    }

    return problemCasesToProcess;
  }
}