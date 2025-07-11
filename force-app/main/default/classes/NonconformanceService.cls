/**
 * @class NonconformanceService
 * @description Service class for creating and linking Nonconformance records to Cases.
 */
public class NonconformanceService {
  /**
   * @description Builds Nonconformance records from given Cases.
   * @param cases List of Case records to convert.
   * @return Map<Id, SQX_Nonconformance__c> Map of Case Ids to new Nonconformance records.
   */
  public static Map<Id, SQX_Nonconformance__c> buildNonconformances(
    List<Case> cases
  ) {
    Map<Id, SQX_Nonconformance__c> caseIdToNonconformanceMap = new Map<Id, SQX_Nonconformance__c>();

    for (Case currentCase : cases) {
      SQX_Nonconformance__c nonconformanceRecord = new SQX_Nonconformance__c(
        SQX_Description__c = currentCase.Description,
        SQX_Priority__c = currentCase.Priority,
        SQX_Title__c = currentCase.Subject,
        SQX_QMS_Reference_Number__c = currentCase.CaseNumber
      );
      caseIdToNonconformanceMap.put(currentCase.Id, nonconformanceRecord);
    }
    return caseIdToNonconformanceMap;
  }

  /**
   * @description Inserts a list of Nonconformance records.
   * @param nonconformances List of Nonconformance records to insert.
   */
  public static void insertNonconformances(
    List<SQX_Nonconformance__c> nonconformances
  ) {
    insert nonconformances;
  }

  /**
   * @description Updates Cases with references to their related Nonconformance records.
   * @param caseToNcMap Map of Case Ids to inserted Nonconformance records.
   */
  public static void updateCasesWithNcRef(
    Map<Id, SQX_Nonconformance__c> caseToNcMap
  ) {
    List<Case> casesToUpdate = new List<Case>();

    for (Id caseId : caseToNcMap.keySet()) {
      SQX_Nonconformance__c nc = caseToNcMap.get(caseId);
      if (nc.Id != null) {
        casesToUpdate.add(new Case(Id = caseId, SQX_NC_Reference__c = nc.Id));
      }
    }

    if (!casesToUpdate.isEmpty()) {
      update casesToUpdate;
    }
  }
}